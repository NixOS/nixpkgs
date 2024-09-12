#!/usr/bin/env python3

import sys
import json
import os
import subprocess
import string


def eprint(text: str):
    print(text, file=sys.stderr)


if not os.path.exists("dub.selections.json"):
    eprint("The file `dub.selections.json` does not exist in the current working directory")
    eprint("run `dub upgrade --annotate` to generate it")
    sys.exit(1)

with open("dub.selections.json") as f:
    selectionsJson = json.load(f)

depsDict: dict = selectionsJson["versions"]

# For each dependency expand non-expanded version into a dict with a "version" key
depsDict = {pname: (versionOrDepDict if isinstance(versionOrDepDict, dict) else {"version": versionOrDepDict}) for (pname, versionOrDepDict) in depsDict.items()}

# Don't process path-type selections
depsDict = {pname: depDict for (pname, depDict) in depsDict.items() if "path" not in depDict}

# Pre-validate selections before trying to fetch
for pname in depsDict:
    depDict = depsDict[pname]
    version = depDict["version"]
    if version.startswith("~"):
        eprint(f'Expected version of "{pname}" to be non-branch type')
        eprint(f'Found: "{version}"')
        eprint("Please specify a non-branch version inside `dub.selections.json`")
        eprint("When packaging, you might also need to patch the version value in the appropriate places (`dub.selections.json`, dub.sdl`, `dub.json`)")
        sys.exit(1)
    if "repository" in depDict:
        repository = depDict["repository"]
        if not repository.startswith("git+"):
            eprint(f'Expected repository field of "{pname}" to begin with "git+"')
            eprint(f'Found: "{repository}"')
            sys.exit(1)
        if (len(version) < 7 or len(version) > 40 or not all(c in string.hexdigits for c in version)):
            eprint(f'Expected version field of "{pname}" to begin be a valid git revision')
            eprint(f'Found: "{version}"')
            sys.exit(1)

lockedDepsDict: dict[str, dict[str, str]] = {}

for pname in depsDict:
    depDict = depsDict[pname]
    version = depDict["version"]
    if "repository" in depDict:
        repository = depDict["repository"]
        strippedRepo = repository[4:]
        eprint(f"Fetching {pname}@{version} ({strippedRepo})")
        command = ["nix-prefetch-git", strippedRepo, version]
        rawRes = subprocess.run(command, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout
        sha256 = json.loads(rawRes)["sha256"]
        lockedDepsDict[pname] = {"version": version, "repository": repository, "sha256": sha256}
    else:
        eprint(f"Fetching {pname}@{version}")
        url = f"https://code.dlang.org/packages/{pname}/{version}.zip"
        command = ["nix-prefetch-url", "--type", "sha256", url]
        sha256 = subprocess.run(command, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.rstrip()
        lockedDepsDict[pname] = {"version": version, "sha256": sha256}

print(json.dumps({"dependencies": lockedDepsDict}, indent=2))
