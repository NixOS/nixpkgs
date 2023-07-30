#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.requests python3.pkgs.beautifulsoup4
import json
import logging
import pathlib
import re
import subprocess
import sys

from bs4 import BeautifulSoup
import requests

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

# See https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#page-header
apache_sort_params='?C=M;O=D'
target_selector=re.compile('(^josm-macos-(\d+)-java(\d{2})\.zip)')

current_path = pathlib.Path(__file__).parent
versions_file_path = current_path.joinpath("versions.json").resolve()

with open(versions_file_path, "r") as versions_file:
    versions = json.load(versions_file)

def nix_prefetch_url(url, algo='sha256'):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, url])
    return out.decode('utf-8').rstrip()

def get_current_version():
    """Get the current revision."""
    logging.info('Opening default.nix')
    return versions["version"]

def hash_to_sri(algorithm: str, value: str):
    out = subprocess.check_output(['nix', "--show-trace", "--extra-experimental-features", "nix-command", "hash", "to-sri", "--type", algorithm, value])
    return out.decode('utf-8').rstrip()


# Check for changes in the macOS release, because this is not as frequently
# updated as the linux release. Hence, we have fewer versions to check.
linux_update_url = 'https://josm.openstreetmap.de/download/'
mac_update_url = linux_update_url + 'macosx/'
logging.info("Checking for updates from %s", linux_update_url)
updates_response = requests.get(mac_update_url + apache_sort_params)

soup = BeautifulSoup(updates_response.text, 'html.parser')

# Find the first Link that matches our selector. This is the
# most recent version, because we already request the listing
# as sorted list.
target_element=soup.find('a', {'href': target_selector})
parsed_info=target_selector.match(target_element['href'])

old_version = get_current_version()
new_version = parsed_info.group(2)
if old_version == new_version:
    logging.info('No new update available.')
    sys.exit(0)

logging.info(f"Update found: josm: {old_version} -> {new_version}")

versions["version"] = new_version
versions["linux"]["hash"] = hash_to_sri('sha256',  nix_prefetch_url(linux_update_url + f"josm-snapshot-{new_version}.jar"))
versions["macosx"]["hash"] = hash_to_sri('sha256', nix_prefetch_url(mac_update_url + target_element['href']))

logging.info(f'Hash (Linux): {versions["linux"]["hash"]}')
logging.info(f'Hash (MacOS): {versions["macosx"]["hash"]}')

logging.info('Updating versions.json...')
with open(versions_file_path, "w") as versions_file:
    json.dump(versions, versions_file, indent=2)
    versions_file.write("\n")

# Commit the result:
logging.info("Committing changes...")
commit_message = f"josm: {old_version} -> {new_version}"
subprocess.run(['git', 'add', versions_file_path], check=True)
subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)

logging.info("Done.")
