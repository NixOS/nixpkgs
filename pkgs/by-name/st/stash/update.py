#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.requests

import json
import requests
import functools
import subprocess
import tempfile
import sys

NAME_TO_PLATFORM_MAP = {
    "stash-linux": "x86_64-linux",
    "stash-linux-arm64v8": "aarch64-linux",
    "stash-macos": "x86_64-darwin",
}


def gen_sri_sha256_hash(file):
    print(f"Generating hash for {file}")
    process = subprocess.run(
        ["nix-hash", "--type", "sha256", "--flat", "--base64", file],
        capture_output=True,
    )
    hash = process.stdout.decode().strip()
    return f"sha256-{hash}"


def download_file_temp(url):
    with tempfile.NamedTemporaryFile() as file:
        print(f"Downloading {url} as {file.name}")
        res = requests.get(url)
        file.write(res.content)
        return gen_sri_sha256_hash(file.name)


def gen_sources_from_release_assets(version, assets):
    filtered_assets = [
        asset
        for asset in assets
        if asset["name"] in ["stash-linux", "stash-macos", "stash-linux-arm64v8"]
    ]

    sources = functools.reduce(
        lambda acc, curr: acc.update(
            {
                NAME_TO_PLATFORM_MAP[curr["name"]]: {
                    "name": curr["name"],
                    "hash": download_file_temp(curr["browser_download_url"]),
                }
            }
        )
        or acc,
        filtered_assets,
        {},
    )

    return {"version": version, "sources": sources}


def main():
    with open(sys.argv[1], mode="r+") as f:
        current_release = json.load(f)

        latest_release = (
            requests.get("https://api.github.com/repos/stashapp/stash/releases/latest")
        ).json()
        latest_version = latest_release["tag_name"]

        if current_release["version"] == latest_version:
            print("No new version available.")
            exit(0)

        current_release.update(
            gen_sources_from_release_assets(latest_version, latest_release["assets"])
        )

        f.seek(0)
        json.dump(current_release, f, indent=2)
        f.write("\n")
        f.truncate()

        print(f"Updated to {latest_version}")


if __name__ == "__main__":
    main()
