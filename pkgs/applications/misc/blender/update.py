#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p git python3 nurl python3Packages.packaging

import json
import subprocess
import re
import os
from packaging.version import parse

# URL *with* trailing slash
url = "https://projects.blender.org/"
blender_repo = "blender/blender"
blender_addons_repo = "blender/blender-addons"

# https://wiki.blender.org/wiki/Reference/Release_Notes
lts_versions = ["2.83", "2.93", "3.3", "3.6"]
active_versions = ["3.3", "3.6", "4.0"]

# List of available Blender versions for nixpkgs
blender_versions = list()
addon_versions = list()
index = dict()


# Retrieve list of matching major+minor versions from newest to oldest
def find_versions(repo, version):
    return re.findall(
        r"v[0-9.]+$",
        subprocess.run([
            "git", "ls-remote", "--tags", "--sort=-version:refname", repo,
            "v" + version + ".*"
        ],
                       capture_output=True,
                       text=True).stdout, re.MULTILINE)


def nix_prefetch_sha256(repo, version, postFetch="", submodules=False):
    print("Getting sha256 hash for {}, v{}".format(repo, version))
    command = [
        'nurl',
        "--fetcher",
        "fetchFromGitea",
        repo,
        "v" + version,
        "-H",
    ]
    if submodules:
        command += ["-S"]
    if postFetch != "":
        command += ["--arg-str", "postFetch", postFetch]
    return subprocess.run(command, capture_output=True, text=True).stdout


if __name__ == "__main__":
    # Get the new newest version of both Blender and blender-addons
    # Also removes the "v" from the beginning of the versions
    for ver in active_versions:
        blender_versions.append(
            find_versions(url + blender_repo, ver)[0].replace("v", ""))
        addon_versions.append(
            find_versions(url + blender_addons_repo, ver)[0].replace("v", ""))

    # Encode all information to JSON
    if blender_versions != addon_versions:
        raise Exception('''
            Available latest Blender versions do not line up with latest Addons versions.
            Check upstream.
        ''')
    else:
        for (version, blender, addon) in zip(active_versions, blender_versions,
                                             addon_versions):
            index[version.replace(".", "_")] = {
                "version": blender,
                "isLTS": version in lts_versions,
                "hashes": {
                    "blender":
                    nix_prefetch_sha256(
                        url + blender_repo,
                        blender,
                        submodules=(True if parse(version) < parse("3.5") else
                                    False)),
                    "addons":
                    nix_prefetch_sha256(
                        url + blender_addons_repo, addon,
                        "patch -p3 -d $out < ${./draco-p2.patch}")
                }
            }

    # Print changes
    print("====== Changes ======\n")
    d = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(d, 'versions.json'), 'r') as f:
        changes = ""
        current = json.load(f)

        # Check for version updates, new versions, and hash mismatches
        for v in index:
            if v in current:
                if index[v]["version"] != current[v]["version"]:
                    changes += "blender_{}: {} -> {}\n".format(
                        v, current[v]["version"], index[v]["version"])
                elif index[v]["hashes"] != current[v]["hashes"]:
                    changes += "blender_{}: correct hash mismatch\n".format(v)
                else:
                    continue
            else:
                changes += "blender_{}: init {}\n".format(
                    v, index[v]["version"])

        # Check if versions removed
        for v in current:
            if v not in index:
                changes += "blender_{}: remove\n".format(v)
            else:
                continue

        if changes == "":
            print("No changes made")
            exit()

        print(changes)
    print("=====================")

    # Write file
    with open(os.path.join(d, 'versions.json'), 'w') as f:
        print("Writing to versions.json...")
        json.dump(index, f, indent=4)
        f.write('\n')
