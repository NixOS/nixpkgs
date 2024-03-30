#!/usr/bin/env python3

import sys
import json
import os
import subprocess

def eprint(text: str):
    print(text, file=sys.stderr)

if not os.path.exists("dub.selections.json"):
    eprint("The file `dub.selections.json` does not exist in the current working directory")
    eprint("run `dub upgrade --annotate` to generate it")
    sys.exit(1)

with open("dub.selections.json") as f:
    selectionsJson = json.load(f)

versionDict: dict[str, str] = selectionsJson["versions"]

for pname in versionDict:
    version = versionDict[pname]
    if version.startswith("~"):
        eprint(f'Package "{pname}" has a branch-type version "{version}", which doesn\'t point to a fixed version')
        eprint("You can resolve it by manually changing the required version to a fixed one inside `dub.selections.json`")
        eprint("When packaging, you might need to create a patch for `dub.sdl` or `dub.json` to accept the changed version")
        sys.exit(1)

lockedDependenciesDict: dict[str, dict[str, str]] = {}

for pname in versionDict:
    version = versionDict[pname]
    eprint(f"Fetching {pname}@{version}")
    url = f"https://code.dlang.org/packages/{pname}/{version}.zip"
    command = ["nix-prefetch-url", "--type", "sha256", url]
    sha256 = subprocess.run(command, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.rstrip()
    lockedDependenciesDict[pname] = {"version": version, "sha256": sha256}

print(json.dumps({"dependencies": lockedDependenciesDict}, indent=2))
