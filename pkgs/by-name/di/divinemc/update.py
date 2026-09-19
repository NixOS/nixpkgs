#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

"""Regenerate versions.json for divinemc.

DivineMC is distributed through the BX Team API, which already exposes a
direct download URL and the SHA-256 checksum for every build, plus the minimum
Java version each Minecraft version requires. That means we never have to
download a jar to hash it and we can pick the right
JRE per version automatically. This script only reshapes that metadata into the
SRI form Nix wants.
"""

import base64
import json
import os
import sys
import urllib.request

API = "https://api.bxteam.org/v1"
PROJECT = "divinemc"


def fetch(path: str):
    request = urllib.request.Request(f"{API}{path}", headers={"User-Agent": "nixpkgs-divinemc-updater"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def to_sri(hex_digest: str) -> str:
    """Convert a hex SHA-256 (as served by the API) to an SRI hash."""
    return "sha256-" + base64.b64encode(bytes.fromhex(hex_digest)).decode()


def build_version(summary: dict) -> dict:
    version = summary["version"]
    build = fetch(f"/builds/{PROJECT}/{version}/latest")
    application = build["downloads"]["application"]

    return {
        "build": build["build"],
        "channel": build["channel"],
        "java": summary["java_min"],
        "url": application["url"],
        "hash": to_sri(application["sha256"]),
    }


def main() -> None:
    latest = fetch(f"/projects/{PROJECT}")["latest"]

    versions = {}
    for summary in fetch(f"/builds/{PROJECT}"):
        if summary["latest_build"] is None:
            continue
        print(f"fetching {summary['version']} ...", file=sys.stderr)
        versions[summary["version"]] = build_version(summary)

    out = {"latest": latest, "versions": versions}

    target = os.path.join(os.path.dirname(os.path.realpath(__file__)), "versions.json")
    with open(target) as handle:
        old = json.load(handle)

    # `supportedFeatures = [ "commit" ]` requires the list of commits to create on
    # stdout, so everything else this script says has to go to stderr.
    if old == out:
        print("[]")
        return

    with open(target, "w") as handle:
        json.dump(out, handle, indent=2)
        handle.write("\n")

    print(f"wrote {len(versions)} versions to {target}", file=sys.stderr)

    commit = {
        "attrPath": "divinemc",
        "oldVersion": old["latest"],
        "newVersion": latest,
        "files": [target],
    }
    if old["latest"] == latest:
        commit["commitMessage"] = "divinemc: update builds"

    print(json.dumps([commit]))


if __name__ == "__main__":
    main()
