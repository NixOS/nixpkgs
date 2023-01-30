#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"
import json
import re
from hashlib import sha1
from struct import unpack
from subprocess import run

from requests import get

# Fetch the latest stable release metadata from GitHub
latestTag = get("https://api.github.com/repos/facebook/sapling/releases/latest").json()[
    "tag_name"
]


def nixPrefetchUrl(url):
    return run(
        ["nix-prefetch-url", "--type", "sha256", url],
        check=True,
        text=True,
        capture_output=True,
    ).stdout.rstrip()


# Fetch the `setup.py` source and look for instances of assets being downloaded
# from files.pythonhosted.org.
setupPy = get(
    f"https://github.com/facebook/sapling/raw/{latestTag}/eden/scm/setup.py"
).text
foundUrls = re.findall(r'(https://files\.pythonhosted\.org/packages/[^\s]+)"', setupPy)

dataDeps = {
    "links": [{"url": url, "sha256": nixPrefetchUrl(url)} for url in foundUrls],
    "version": latestTag,
    # Find latest's git tag which corresponds to the Sapling version. Also
    # needed is a hash of the version, so calculate that here. Taken from
    # Sapling source `$root/eden/scm/setup_with_version.py`.
    "versionHash": str(unpack(">Q", sha1(latestTag.encode("ascii")).digest()[:8])[0]),
}

open("deps.json", "w").write(json.dumps(dataDeps, indent=2, sort_keys=True) + "\n")
