#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p cargo -p "python3.withPackages (ps: with ps; [ requests ])"
import json
import pathlib
import re
import tempfile
import os
import shutil
from hashlib import sha1
from struct import unpack
from subprocess import run
import subprocess

from requests import get

# Fetch the latest stable release metadata from GitHub
releaseMetadata = get("https://api.github.com/repos/facebook/sapling/releases/latest").json()
latestTag = releaseMetadata["tag_name"]
latestTarballURL = releaseMetadata["tarball_url"]

[_tarballHash, sourceDirectory] = run(
    ["nix-prefetch-url", "--print-path", "--unpack", latestTarballURL],
    check=True,
    text=True,
    stdout=subprocess.PIPE,
).stdout.rstrip().splitlines()

def updateCargoLock():
    with tempfile.TemporaryDirectory() as tempDir:
        tempDir = pathlib.Path(tempDir)

        # NOTE(strager): We cannot use shutil.tree because it copies the
        # read-only permissions.
        for dirpath, dirnames, filenames in os.walk(sourceDirectory):
            relativeDirpath = os.path.relpath(dirpath, sourceDirectory)
            for filename in filenames:
                shutil.copy(os.path.join(dirpath, filename), tempDir / relativeDirpath / filename)
            for dirname in dirnames:
                os.mkdir(tempDir / relativeDirpath / dirname)

        run(["cargo", "fetch"], check=True, cwd=tempDir / "eden" / "scm")
        shutil.copy(tempDir / "eden" / "scm" / "Cargo.lock", "Cargo.lock")

updateCargoLock()

def nixPrefetchUrl(url):
    return run(
        ["nix-prefetch-url", "--type", "sha256", url],
        check=True,
        text=True,
        capture_output=True,
    ).stdout.rstrip()


# Fetch the `setup.py` source and look for instances of assets being downloaded
# from files.pythonhosted.org.
setupPy = (pathlib.Path(sourceDirectory) / "eden/scm/setup.py").read_text()
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
