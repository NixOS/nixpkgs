#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.httpx ps.socksio ])"

import json
import os
import pathlib
import subprocess

import httpx

platforms = {
    "x86_64-linux": "x86_64-linux",
    "aarch64-linux": "aarch64-linux",
    "aarch64-darwin": "aarch64-macos",
    "x86_64-darwin": "x86_64-macos",
}


def main() -> None:
    headers = {}
    token = os.getenv("GITHUB_TOKEN")
    if token is not None:
        headers["Authorization"] = "Bearer {}".format(token)

    resp = httpx.get(
        "https://api.github.com/repos/justrach/codegraff/releases/latest",
        headers=headers,
    )

    latest_release = resp.json().get("tag_name")
    version = latest_release.removeprefix("v")

    assets = {
        "version": version,
        "assets": {},
    }

    for k, v in platforms.items():
        url = "https://github.com/justrach/codegraff/releases/download/v{}/graff-{}.tar.gz".format(
            version, v
        )

        process = subprocess.run(
            ["nix-prefetch-url", "--type", "sha256", url],
            capture_output=True,
            text=True,
        )

        process.check_returncode()

        process = subprocess.run(
            ["nix-hash", "--type", "sha256", "--to-sri", process.stdout.rstrip()],
            capture_output=True,
            text=True,
        )

        process.check_returncode()

        hash = process.stdout.rstrip()
        assets["assets"][k] = {
            "url": url,
            "hash": hash,
        }

    (pathlib.Path(__file__).parent / "manifest.json").write_text(
        json.dumps(assets, indent=2) + "\n"
    )


if __name__ == "__main__":
    main()
