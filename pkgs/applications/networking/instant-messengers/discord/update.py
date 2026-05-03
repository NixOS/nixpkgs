#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

from dataclasses import asdict, dataclass, field
from enum import StrEnum
from typing import List
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


class Kind(StrEnum):
    # Single tarball or dmg fetched via discord.com/api/download redirect
    LEGACY = "legacy"
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


def url_for_variant(variant: Variant) -> str:
    return f"https://discord.com/api/download/{variant.branch.value}?platform={variant.platform.value}&format={variant.platform.format_type()}"


def distro_manifest_url_for_variant(variant: Variant) -> str:
    return f"https://updates.discord.com/distributions/app/manifests/latest?channel={variant.branch.value}&platform={variant.platform.value}&arch=x64"


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


@dataclass
class LegacySource:
    version: str
    url: str
    hash: str
    kind: Kind = Kind.LEGACY


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


def fetch_distro_source(variant: Variant) -> DistroSource:
    manifest = fetch_distro_manifest(variant)

    distro_url = manifest["full"]["url"]
    modules = {
        name: DistroModule(
            version=mod["full"]["module_version"],
            url=mod["full"]["url"],
            hash=prefetch(mod["full"]["url"]),
        )
        for name, mod in manifest["modules"].items()
    }

    return DistroSource(
        version=version_triple_to_str(manifest["full"]["host_version"]),
        distro=DistroRef(url=distro_url, hash=prefetch(distro_url)),
        modules=modules,
    )


def fetch_legacy_source(variant: Variant) -> LegacySource:
    url = fetch_redirect_url(url_for_variant(variant))
    return LegacySource(
        version=version_from_url(url),
        url=url,
        hash=prefetch(url),
    )


def main():
    variants: List[Variant] = [
        Variant(Platform.LINUX, Branch.STABLE, Kind.LEGACY),
        Variant(Platform.LINUX, Branch.PTB, Kind.DISTRO),
        Variant(Platform.LINUX, Branch.CANARY, Kind.DISTRO),
        Variant(Platform.LINUX, Branch.DEVELOPMENT, Kind.DISTRO),
        Variant(Platform.MACOS, Branch.STABLE, Kind.LEGACY),
        Variant(Platform.MACOS, Branch.PTB, Kind.LEGACY),
        Variant(Platform.MACOS, Branch.CANARY, Kind.LEGACY),
        Variant(Platform.MACOS, Branch.DEVELOPMENT, Kind.LEGACY),
    ]

    sources = {}

    for v in variants:
        source = (
            fetch_distro_source(v) if v.kind == Kind.DISTRO else fetch_legacy_source(v)
        )
        sources[serialize_variant(v)] = asdict(source)

    with open(os.path.join(os.path.dirname(__file__), "sources.json"), "w") as f:
        json.dump(sources, f, indent=2, sort_keys=True)
        f.write("\n")


if __name__ == "__main__":
    main()
