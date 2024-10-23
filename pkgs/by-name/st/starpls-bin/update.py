#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.httpx ps.socksio ])"

import base64
import hashlib
import json
import pathlib

import httpx

platforms = {
    "x86_64-linux": "linux-amd64",
    "aarch64-linux": "linux-aarch64",
    "aarch64-darwin": "darwin-arm64",
}

if __name__ == "__main__":
    resp = httpx.get(
        "https://api.github.com/repos/withered-magic/starpls/releases/latest"
    )

    latest_release = resp.json().get("tag_name")
    version = latest_release.removeprefix("v")

    assets = {
        "version": version,
        "assets": {},
    }

    for k, v in platforms.items():
        url = "https://github.com/withered-magic/starpls/releases/download/v{}/starpls-{}".format(
            version, v
        )

        h = hashlib.sha256()
        with httpx.stream("GET", url, follow_redirects=True) as resp:
            for b in resp.iter_bytes(4096):
                h.update(b)
        digest = h.digest()

        hash = "sha256-{}".format(base64.b64encode(digest).decode())

        assets["assets"][k] = {
            "url": url,
            "hash": hash,
        }

    (pathlib.Path(__file__).parent / "manifest.json").write_text(
        json.dumps(assets, indent=2) + "\n"
    )
