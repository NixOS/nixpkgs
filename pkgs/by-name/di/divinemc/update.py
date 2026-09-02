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

API = "https://api.bxteam.org/atlas/projects/divinemc"


def fetch(path: str) -> dict:
    request = urllib.request.Request(f"{API}{path}", headers={"User-Agent": "nixpkgs-divinemc-updater"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def to_sri(hex_digest: str) -> str:
    """Convert a hex SHA-256 (as served by the API) to an SRI hash."""
    return "sha256-" + base64.b64encode(bytes.fromhex(hex_digest)).decode()


def version_keys(project: dict) -> list[str]:
    """Flatten the API's version_groups into a plain list of version keys."""
    return [key for group in project["version_groups"].values() for key in group]


def build_version(version: str) -> dict:
    info = fetch(f"/versions/{version}")["version"]
    java = info.get("java", {}).get("version", {}).get("minimum")

    build = fetch(f"/versions/{version}/builds/latest")
    application = build["downloads"]["application"]

    return {
        "build": build["id"],
        "channel": build["channel"],
        "java": java,
        "url": application["url"],
        "hash": to_sri(application["checksums"]["sha256"]),
    }


def main() -> None:
    # `GET /projects/divinemc` returns {"project": ..., "version_groups": ...}
    root = fetch("")
    latest = root["project"]["latestVersion"]

    versions = {}
    for version in version_keys(root):
        print(f"fetching {version} ...", file=sys.stderr)
        versions[version] = build_version(version)

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
