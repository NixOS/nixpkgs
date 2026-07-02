#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

from dataclasses import asdict, dataclass, field
from enum import StrEnum
from typing import List
import base64
import json
import urllib.request
import os.path


class Platform(StrEnum):
    LINUX = "linux"
    MACOS = "osx"


class Branch(StrEnum):
    STABLE = "stable"
    PTB = "ptb"
    CANARY = "canary"
    DEVELOPMENT = "development"


class Kind(StrEnum):
    # Brotli-compressed host + module distros from the distributions API
    DISTRO = "distro"


@dataclass(frozen=True)
class Variant:
    platform: Platform
    branch: Branch
    kind: Kind


# The distributions API rejects requests that don't send a Discord-Updater
# User-Agent, so we can't identify ourselves as Nixpkgs here
DISTRO_USER_AGENT = "Discord-Updater/1"


def serialize_variant(variant: Variant) -> str:
    return f"{variant.platform}-{variant.branch}"


def distro_manifest_url_for_variant(variant: Variant) -> str:
    return f"https://updates.discord.com/distributions/app/manifests/latest?channel={variant.branch.value}&platform={variant.platform.value}&arch=x64"


@dataclass
class DistroRef:
    url: str
    hash: str


@dataclass
class DistroModule:
    version: int
    url: str
    hash: str


@dataclass
class DistroSource:
    version: str
    distro: DistroRef
    modules: dict[str, DistroModule] = field(default_factory=dict)
    kind: Kind = Kind.DISTRO


def fetch_distro_manifest(variant: Variant) -> dict:
    url = distro_manifest_url_for_variant(variant)
    req = urllib.request.Request(url, headers={"User-Agent": DISTRO_USER_AGENT})
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read())


def version_triple_to_str(triple: list) -> str:
    return ".".join(str(x) for x in triple)


def sri_from_sha256_hex(hex_hash: str) -> str:
    return "sha256-" + base64.b64encode(bytes.fromhex(hex_hash)).decode("utf-8")


def fetch_distro_source(variant: Variant) -> DistroSource:
    manifest = fetch_distro_manifest(variant)

    distro_url = manifest["full"]["url"]
    modules = {
        name: DistroModule(
            version=mod["full"]["module_version"],
            url=mod["full"]["url"],
            hash=sri_from_sha256_hex(mod["full"]["package_sha256"]),
        )
        for name, mod in manifest["modules"].items()
    }

    return DistroSource(
        version=version_triple_to_str(manifest["full"]["host_version"]),
        distro=DistroRef(
            url=distro_url,
            hash=sri_from_sha256_hex(manifest["full"]["package_sha256"]),
        ),
        modules=modules,
    )


def main():
    variants: List[Variant] = [
        Variant(Platform.LINUX, Branch.STABLE, Kind.DISTRO),
        Variant(Platform.LINUX, Branch.PTB, Kind.DISTRO),
        Variant(Platform.LINUX, Branch.CANARY, Kind.DISTRO),
        Variant(Platform.LINUX, Branch.DEVELOPMENT, Kind.DISTRO),
        Variant(Platform.MACOS, Branch.STABLE, Kind.DISTRO),
        Variant(Platform.MACOS, Branch.PTB, Kind.DISTRO),
        Variant(Platform.MACOS, Branch.CANARY, Kind.DISTRO),
        Variant(Platform.MACOS, Branch.DEVELOPMENT, Kind.DISTRO),
    ]

    sources = {}

    for v in variants:
        sources[serialize_variant(v)] = asdict(fetch_distro_source(v))

    with open(os.path.join(os.path.dirname(__file__), "sources.json"), "w") as f:
        json.dump(sources, f, indent=2, sort_keys=True)
        f.write("\n")


if __name__ == "__main__":
    main()
