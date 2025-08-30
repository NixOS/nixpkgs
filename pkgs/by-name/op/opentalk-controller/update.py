#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ requests beautifulsoup4 ])" -p nix-update

import requests
import bs4
import subprocess
import os
import sys


def query_latest_release():
    response = requests.get("https://docs.opentalk.eu/releases/")
    response.raise_for_status()
    soup = bs4.BeautifulSoup(response.text, "html.parser")
    node = soup.select_one(
        "article > div.markdown > ul > li > a[href^='/releases/'] > strong"
    )
    assert node
    return node.get_text(strip=True)[1:]


def scrape_release(version: str):
    url = f"https://docs.opentalk.eu/releases/{version}/"
    response = requests.get(url)
    response.raise_for_status()
    return bs4.BeautifulSoup(response.text, "html.parser")


print("Querying latest release version")
release_version = query_latest_release()
print("Latest release:", release_version)
print("Scraping release table for component versions")
soup = scrape_release(release_version)
pname = os.getenv("UPDATE_NIX_PNAME")
assert pname
attr_path = os.getenv("UPDATE_NIX_ATTR_PATH")
assert attr_path
prefix = "opentalk-"
assert pname.startswith(prefix)
component = pname[len(prefix) :]

selector = f"td:has(> a[href='/releases/components/{component}/']) + td"
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
