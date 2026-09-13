#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.httpx ps.socksio ])"

import base64
import json
import pathlib
import re

import httpx

CHANNEL_URL = "https://api.meta.ai/muse-code/channels/muse-stable"

platforms = {
    "x86_64-linux": "x86_linux",
    "aarch64-linux": "aarch64_linux",
    "aarch64-darwin": "aarch64_macos",
    "x86_64-darwin": "x86_macos",
}


def split_version(full):
    m = re.match(r"^(.*)-R(.*)$", full)
    if m:
        return m.group(1), "R" + m.group(2)
    return full, full


def to_sri(hex_digest):
    return "sha256-" + base64.b64encode(bytes.fromhex(hex_digest)).decode()


def main() -> None:
    resp = httpx.get(CHANNEL_URL)
    resp.raise_for_status()
    channel = resp.json()

    version, build = split_version(channel["version"])

    resp = httpx.get(channel["manifest_url"])
    resp.raise_for_status()
    artifacts = resp.json()["artifacts"]

    assets = {
        "version": version,
        "build": build,
        "assets": {},
    }

    for k, v in platforms.items():
        info = artifacts[v]
        assets["assets"][k] = {
            "url": info["url"],
            "hash": to_sri(info["checksum"]),
        }

    (pathlib.Path(__file__).parent / "manifest.json").write_text(
        json.dumps(assets, indent=2) + "\n"
    )


if __name__ == "__main__":
    main()
