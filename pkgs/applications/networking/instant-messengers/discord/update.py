#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

from enum import StrEnum
from typing import List, Tuple
from subprocess import PIPE, Popen
import json
import urllib.request
import re
import os.path

SRC_NAME = "source"

VERSION_REGEX = re.compile(r"\/([\d.]+)\/")


class Platform(StrEnum):
    LINUX = "linux"
    MACOS = "osx"

    def format_type(self):
        if self.value == Platform.LINUX.value:
            return "tar.gz"
        elif self.value == Platform.MACOS.value:
            return "dmg"
        raise RuntimeError("Invalid platform")


class Branch(StrEnum):
    STABLE = "stable"
    PTB = "ptb"
    CANARY = "canary"
    DEVELOPMENT = "development"


Variant = Tuple[Platform, Branch]


def serialize_variant(variant: Variant) -> str:
    platform, branch = variant
    return f"{platform}-{branch}"


def url_for_variant(variant: Variant) -> str:
    platform, branch = variant

    return f"https://discord.com/api/download/{branch.value}?platform={platform.value}&format={platform.format_type()}"


def fetch_redirect_url(url: str) -> str:
    headers = {"user-agent": "Nixpkgs-Discord-Update-Script/0.0.0"}
    # note that urllib follows redirects by default. So we can extract the final url from the response object
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        return response.url


def version_from_url(url: str) -> str:
    matches = VERSION_REGEX.search(url)
    assert matches, f"Url {url} must contain version number"
    version = matches.group(1)
    assert version
    return version


def prefetch(url: str) -> str:
    with Popen(["nix-prefetch-url", "--name", "source", url], stdout=PIPE) as p:
        assert p.stdout
        b32_hash = p.stdout.read().decode("utf-8").strip()
    with Popen(
        ["nix-hash", "--to-sri", "--type", "sha256", b32_hash], stdout=PIPE
    ) as p:
        assert p.stdout
        sri_hash = p.stdout.read().decode("utf-8").strip()
    return sri_hash


def main():
    variants: List[Variant] = [
        (Platform.LINUX, Branch.STABLE),
        (Platform.LINUX, Branch.PTB),
        (Platform.LINUX, Branch.CANARY),
        (Platform.LINUX, Branch.DEVELOPMENT),
        (Platform.MACOS, Branch.STABLE),
        (Platform.MACOS, Branch.PTB),
        (Platform.MACOS, Branch.CANARY),
        (Platform.MACOS, Branch.DEVELOPMENT),
    ]

    sources = {}

    for v in variants:
        url = url_for_variant(v)
        url = fetch_redirect_url(url)
        version = version_from_url(url)
        sri_hash = prefetch(url)

        sources[serialize_variant(v)] = {
            "url": url,
            "version": version,
            "hash": sri_hash,
        }

    with open(os.path.join(os.path.dirname(__file__), "sources.json"), "w") as f:
        json.dump(sources, f, indent=2, sort_keys=True)
        f.write("\n")


if __name__ == "__main__":
    main()
