#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.packaging python3Packages.debian

from urllib import request
import gzip
import base64

from debian.deb822 import Packages
from debian.debian_support import Version

# Download and extract the package list file
packages_url = 'https://packages.microsoft.com/repos/edge/dists/stable/main/binary-amd64/Packages.gz'
handle = request.urlopen(packages_url)
data = gzip.GzipFile(fileobj=handle).read()

# Find latest version for each channel
latest_packages: dict[str, Packages] = {}
for package in Packages.iter_paragraphs(data, use_apt_pkg=False):
  name: str = package['Package']
  if not name.startswith('microsoft-edge-'):
    continue
  channel = name.replace('microsoft-edge-', '')
  if channel not in latest_packages:
    latest_packages[channel] = package
  else:
    old_package = latest_packages[channel]
    if old_package.get_version() < package.get_version():  # type: ignore
      latest_packages[channel] = package

# Generate a Nix expression for each channel
channel_strs: list[str] = []
for channel, package in latest_packages.items():
  match = Version.re_valid_version.match(package['Version'])
  assert match is not None

  version = match.group('upstream_version')
  revision = match.group('debian_revision')
  sri = 'sha256-' + base64.b64encode(bytes.fromhex(package['SHA256'])).decode('ascii')

  channel_strs.append(f'''
  {channel} = import ./browser.nix {{
    channel = "{channel}";
    version = "{version}";
    revision = "{revision}";
    sha256 = "{sri}";
  }};''')

# Write the final expression
nix_expr = f'''{{{'  '.join(channel_strs)}
}}'''
with open('default.nix', 'w') as f:
  f.write(nix_expr)
