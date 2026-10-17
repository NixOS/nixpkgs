#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ requests beautifulsoup4 semver ])" -p nix-update

import os
import re
import subprocess
import sys
from xml.etree import ElementTree

import bs4
import requests
import semver


def query_latest_release():
    response = requests.get(
        "https://gitlab.opencode.de/opentalk/ot-setup/-/tags?format=atom"
    )
    response.raise_for_status()
    tree = ElementTree.fromstring(response.content)

    version_pattern = re.compile(r"^v(\d+\.\d+\.\d+)$")
    ns = {"atom": "http://www.w3.org/2005/Atom"}
    versions = []
    for entry in tree.findall("atom:entry", ns):
        tag_title = entry.find("atom:title", ns)
        if tag_title is None or tag_title.text is None:
            continue
        match = version_pattern.match(tag_title.text)
        if match:
            versions.append(semver.Version.parse(match.group(1)))

    return str(max(versions))


def scrape_release(version: str):
    url = f"https://docs.opentalk.eu/releases/{version}/"
    response = requests.get(url)
    response.raise_for_status()
    return bs4.BeautifulSoup(response.text, "html.parser")


pname = os.getenv("UPDATE_NIX_PNAME")
assert pname
attr_path = os.getenv("UPDATE_NIX_ATTR_PATH")
assert attr_path
prefix = "opentalk-"
assert pname.startswith(prefix)
component = pname[len(prefix) :]

print("Querying latest release version")
release_version = query_latest_release()
print("Latest release:", release_version)
print("Scraping release table for component versions")
soup = scrape_release(release_version)

selector = f"td:has(> a[href='../components/{component}/']) + td"
node = soup.select_one(selector)
if not node:
    print("Component", component, "is missing in release table")
    sys.exit(1)

version = node.get_text(strip=True)[1:]
if version == os.getenv("UPDATE_NIX_OLD_VERSION"):
    print(pname, "already is at version", version)
else:
    print("Updating", pname, "to version", version)
    subprocess.run(["nix-update", "--version", version, attr_path], check=True)
