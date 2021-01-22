FROM debian:buster-slim

MAINTAINER Zane Claes <zane@technicallywizardry.com>

ENV NTM_INTERFACE eth0
ENV NTM_PORT 8500
ENV NTM_FILTERS "(src net 192.168.1.0/24 and not dst net 192.168.1.0/24) or (dst net 192.168.1.0/24 and not src net 192.168.1.0/24)"
ENV NTM_PREFIX "src net 192.168.1.1/24"

USER root

RUN apt-get clean -y && apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip python3-setuptools && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install argparse prometheus_client

RUN apt-get update -y && apt-get install -y tcpdump

COPY services /etc/services
COPY network-traffic-metrics.py /usr/bin/network-traffic-metrics.py
RUN chmod +x /usr/bin/network-traffic-metrics.py
CMD /usr/bin/network-traffic-metrics.py -i ${NTM_INTERFACE} -p ${NTM_PORT} --fqdn

EXPOSE ${NTM_PORT}
