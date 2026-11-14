#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3
"""
Fetches the latest manifest from the official distribution CDN.

Relevant links:
    https://download-global.papertracker.top/papertracker/versions.jsonl
    https://download-global.papertracker.top/papertracker/linux/x64/stable/current.json
    https://download-global.papertracker.top/papertracker/linux/x64/stable/manifests/{manifest}.json
"""

import argparse
import hashlib
import json
import urllib.request
from pathlib import Path


def fetch(url: str) -> bytes:
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "nixpkgs <https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/pa/papertracker/package.nix>"
        },
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        return resp.read()


def main() -> None:
    parser = argparse.ArgumentParser(description="Update Paper_Tracker package")
    parser.add_argument("--channel", choices=["stable", "beta"], default="stable")
    parser.add_argument("--platform", choices=["linux", "windows"], default="linux")
    parser.add_argument("--arch", choices=["x64"], default="x64")
    args = parser.parse_args()

    print(f"channel: {args.channel}")
    print(f"platform: {args.platform}")
    print(f"arch: {args.arch}")

    base_url = f"https://download-global.papertracker.top/papertracker/{args.platform}/{args.arch}/{args.channel}"

    current = json.loads(fetch(f"{base_url}/current.json"))
    version = current["version"]
    manifest_hash = current["manifest_sha256"]
    manifest_url = f"{base_url}/manifests/{manifest_hash}.json"

    manifest = fetch(manifest_url)
    actual_hash = hashlib.sha256(manifest).hexdigest()
    if actual_hash != manifest_hash:
        raise SystemExit(
            f"manifest hash mismatch: expected {manifest_hash}, got {actual_hash}"
        )

    print(f"version: {version}")
    print(f"hash: {actual_hash}")
    print(f"manifest: {manifest_url}")

    manifest_path = Path(__file__).with_name("manifest.json")
    manifest_path.write_bytes(manifest)
    print(f"updated {manifest_path}")


if __name__ == "__main__":
    main()
