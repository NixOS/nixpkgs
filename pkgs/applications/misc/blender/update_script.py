#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.requests python3.pkgs.beautifulsoup4
import fileinput
import logging
import pathlib
import re
import subprocess
import sys

from bs4 import BeautifulSoup
from packaging import version
import requests

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)


CHECK_URL = 'https://download.blender.org/source/'
target_selector=re.compile('(blender-(?!with-libraries)(?P<version>.+).tar.xz$)')

current_path = pathlib.Path(__file__).parent
DEFAULT_NIX = current_path.joinpath("default.nix").resolve()
logging.info(DEFAULT_NIX)

def nix_prefetch_url(url, algo='sha256'):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, url])
    return out.decode('utf-8').rstrip()

def get_current_version():
    """Get the current version."""
    logging.info('Opening default.nix')
    with open(DEFAULT_NIX) as f:
        for line in f:
            rev = re.search(r'^  version = "(.*)";', line)
            if rev:
                return rev.group(1)
    logging.error("Could not open default.nix")
    sys.exit(1)

def hash_to_sri(algorithm: str, value: str):
    out = subprocess.check_output(['nix', "--show-trace", "--extra-experimental-features", "nix-command", "hash", "to-sri", "--type", algorithm, value])
    return out.decode('utf-8').rstrip()

def find_latest_version():
    updates_response = requests.get(CHECK_URL)
    soup = BeautifulSoup(updates_response.text, 'html.parser')
    # Find the first Link that matches our selector. Because
    # Blender uses Nginx, which has no sorting options, we need
    # to loop over every link.
    target_elements=soup.find_all('a', {'href': target_selector})
    last_version = version.parse("0")
    for possible_target in target_elements:
        matches = target_selector.match(possible_target['href'])
        matched_version = matches.group('version') if matches and matches.group('version') else "0"
        parsed_version = version.parse(matched_version)
        if parsed_version > last_version:
            last_version = parsed_version
    return {"link": possible_target['href'], "version": matched_version}

current_version = get_current_version()
logging.info(current_version)
new_version = find_latest_version()

if new_version['version'] == current_version:
    logging.info('#### No update found ####')
    sys.exit(0)

logging.info(f"Update found: blender: {current_version} -> {new_version['version']}")
new_hash = hash_to_sri('sha256',  nix_prefetch_url(CHECK_URL + f"{new_version['link']}"))

with fileinput.FileInput(DEFAULT_NIX, inplace=True) as f:
    for line in f:
        result = re.sub(r'^  version = ".+";', f'  version = "{new_version["version"]}";', line)
        result = re.sub(r'^    hash = ".+";', f'    hash = "{new_hash}";', result)
        print(result, end='')

# Commit the result:
logging.info("Committing changes...")
commit_message = f"blender: {current_version} -> {new_version['version']}"
subprocess.run(['git', 'add', DEFAULT_NIX], check=True)
subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)

logging.info("Done.")
