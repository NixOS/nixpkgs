"""
Maven doesn't honor HTTP[S]_PROXY and NO_PROXY env vars out of the box.
Instead, it expects the user to configure a settings.xml file.
We however impurely pass only these env vars in FODs.
This creates the XML file on demand, if one or more env vars is set.
"""

import os
import sys
from urllib.parse import urlparse


def parse_proxy_url(url):
    if url is None:
        return None
    parsed = urlparse(url)

    if parsed.hostname is None:
        print(f"Failed to parse proxy URL {url}, ignoring", file=sys.stderr)
        return None

    return {
        'protocol': parsed.scheme or 'http',
        'host': parsed.hostname,
        'port': parsed.port or (443 if parsed.scheme == 'https' else 80),
        'username': parsed.username,
        'password': parsed.password
    }


def format_proxy_block(proxy, id_suffix, non_proxy_hosts):
    auth = ""
    if proxy.get("username"):
        auth += f"    <username>{proxy['username']}</username>\n"
    if proxy.get("password"):
        auth += f"    <password>{proxy['password']}</password>\n"

    np_hosts = ""
    if non_proxy_hosts:
        np_hosts = f"    <nonProxyHosts>{non_proxy_hosts}</nonProxyHosts>\n"

    return f"""  <proxy>
    <id>{id_suffix}-proxy</id>
    <active>true</active>
    <protocol>{proxy['protocol']}</protocol>
    <host>{proxy['host']}</host>
    <port>{proxy['port']}</port>
{auth}{np_hosts}  </proxy>"""


def main(output_path):
    http_proxy = parse_proxy_url(os.environ.get("HTTP_PROXY"))
    https_proxy = parse_proxy_url(os.environ.get("HTTPS_PROXY"))
    non_proxy_hosts = os.environ.get("NO_PROXY", "").replace(",", "|")

    proxy_blocks = []

    if http_proxy:
        proxy_blocks.append(
          format_proxy_block(http_proxy, "http", non_proxy_hosts)
        )
    if https_proxy and https_proxy != http_proxy:
        proxy_blocks.append(
          format_proxy_block(https_proxy, "https", non_proxy_hosts)
        )

    settings_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                  http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <proxies>
{'\n'.join(proxy_blocks)}
  </proxies>
</settings>
"""

    with open(output_path, "w") as f:
        f.write(settings_xml)

    print(f"Generated Maven settings.xml at {output_path}")


if __name__ == "__main__":
    output_file = sys.argv[1] if len(sys.argv) > 1 else "settings.xml"
    main(output_file)
