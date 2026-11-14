#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: [ ps.requests ])"

import base64
import os
import re
import sys

import requests

API = "https://fill.papermc.io/v3/projects/folia"
TIMEOUT = 30

PINNED_JAVA = 25


def get_json(url: str):
    resp = requests.get(url, timeout=TIMEOUT)
    resp.raise_for_status()
    return resp.json()


def minecraft_version_key(version: str) -> list[int]:
    return [int(part) for part in version.split(".")]


def minecraft_versions() -> list[str]:
    groups = get_json(API)["versions"]
    versions = [
        v
        for ids in groups.values()
        for v in ids
        if re.fullmatch(r"\d+(\.\d+)*", v)
    ]
    return sorted(versions, key=minecraft_version_key, reverse=True)


def latest_stable_build():
    for mc_version in minecraft_versions():
        resp = get_json(f"{API}/versions/{mc_version}")
        java_min = (
            resp.get("version", {})
            .get("java", {})
            .get("version", {})
            .get("minimum")
        )
        for build in sorted(resp["builds"], reverse=True):
            detail = get_json(f"{API}/versions/{mc_version}/builds/{build}")
            if detail["channel"] == "STABLE":
                download = detail["downloads"]["server:default"]
                return (
                    mc_version,
                    build,
                    download["url"],
                    download["checksums"]["sha256"],
                    java_min,
                )
    raise RuntimeError("no stable Folia build found")


def to_sri(sha256_hex: str) -> str:
    return "sha256-" + base64.b64encode(bytes.fromhex(sha256_hex)).decode()


def main() -> None:
    mc_version, build, url, sha256_hex, java_min = latest_stable_build()
    version = f"{mc_version}-{build}"
    sri = to_sri(sha256_hex)

    if java_min is not None and java_min != PINNED_JAVA:
        print(
            f"ERROR: Folia {version} requires Java {java_min}, but package.nix "
            f"pins jdk{PINNED_JAVA}_headless. Update the jdk input in package.nix "
            f"and PINNED_JAVA in this script to match, then re-run.",
            file=sys.stderr,
        )
        sys.exit(1)

    package_nix = os.path.join(
        os.path.dirname(os.path.realpath(__file__)), "package.nix"
    )
    with open(package_nix) as f:
        content = f.read()

    content = re.sub(r'version = "[^"]*";', f'version = "{version}";', content, count=1)
    content = re.sub(r'url = "[^"]*";', f'url = "{url}";', content, count=1)
    content = re.sub(r'hash = "[^"]*";', f'hash = "{sri}";', content, count=1)

    with open(package_nix, "w") as f:
        f.write(content)

    print(f"folia: updated to {version}")


if __name__ == "__main__":
    main()
