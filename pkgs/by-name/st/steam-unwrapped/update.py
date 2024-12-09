#!/usr/bin/env nix-shell
#!nix-shell --pure --keep NIX_PATH -i python3 -p git nix-update "python3.withPackages (ps: [ ps.beautifulsoup4 ps.requests ])"

import sys
import re
import requests
import subprocess
from bs4 import BeautifulSoup

VERSION_PATTERN = re.compile(r'^steam_(?P<ver>(\d+\.)+)tar.gz$')

found_versions = []
response = requests.get("https://repo.steampowered.com/steam/archive/stable/")
soup = BeautifulSoup (response.text, "html.parser")
for a in soup.find_all("a"):
    href = a["href"]
    if not href.endswith(".tar.gz"):
        continue

    match = VERSION_PATTERN.match(href)
    if match is not None:
        version = match.groupdict()["ver"][0:-1]
        found_versions.append(version)

if len(found_versions) == 0:
    print("Failed to find available versions!", file=sys.stderr)
    sys.exit(1)

found_versions.sort()
subprocess.run(["nix-update", "--version", found_versions[-1], "steam-unwrapped"])
found_versions[0]
