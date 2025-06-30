#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages(ps: [ps.requests ps.plumbum])' nix-prefetch
import json
import requests

from pathlib import Path

from plumbum.cmd import nix_prefetch_url

HERE = Path(__file__).parent
SUFFIXES = (
    ("x86_64-linux", ".AppImage"),
    ("x86_64-darwin", ".dmg"),
    ("aarch64-darwin", "-arm64.dmg"),
)

latest = requests.get(
    "https://api.github.com/repos/laurent22/joplin/releases/latest"
).json()
tag = latest["tag_name"]
version = tag[1:]
release = {
    "version": version,
}

for arch, suffix in SUFFIXES:
    url = f"https://github.com/laurent22/joplin/releases/download/v{version}/Joplin-{version}{suffix}"
    release[arch] = {"url": url, "sha256": nix_prefetch_url(url).strip()}

with HERE.joinpath("release-data.json").open("w") as fd:
    json.dump(release, fd, indent=2)
    fd.write("\n")
