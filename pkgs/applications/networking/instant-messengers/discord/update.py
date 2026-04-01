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
import tempfile
import zipfile

SRC_NAME = "source"

VERSION_REGEX = re.compile(r"\/([\d.]+)\/")

# pmovmskb %xmm0, %eax + cmp $0xffff, %eax
KRISP_PATCH_SIGNATURE = b"\x66\x0f\xd7\xc0\x3d\xff\xff\x00\x00"
# Apple Security framework API used as the anchor for Mach-O call-chain tracing
ANCHOR_IMPORT = b"_SecStaticCodeCreateWithPath"


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


def fetch_krisp_module_url(branch, version, platform):
    """Return the krisp module download URL, or None if unavailable."""
    headers = {"user-agent": "Nixpkgs-Discord-Update-Script/0.0.0"}
    url = f"https://discord.com/api/modules/{branch.value}/versions.json?host_version={version}&platform={platform.value}"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        modules = json.loads(response.read())

    if "discord_krisp" not in modules:
        return None

    krisp_ver = modules["discord_krisp"]
    download_url = f"https://discord.com/api/modules/{branch.value}/discord_krisp/{krisp_ver}?host_version={version}&platform={platform.value}"
    return fetch_redirect_url(download_url)


def verify_krisp_patchable(url):
    """Download krisp and check it contains the expected patchable target."""
    headers = {"user-agent": "Nixpkgs-Discord-Update-Script/0.0.0"}
    with tempfile.TemporaryDirectory() as tmpdir:
        zip_path = os.path.join(tmpdir, "krisp.zip")
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as resp, open(zip_path, "wb") as f:
            f.write(resp.read())

        with zipfile.ZipFile(zip_path) as zf:
            if "discord_krisp.node" not in zf.namelist():
                print("  WARNING: discord_krisp.node not found in zip")
                return False
            zf.extract("discord_krisp.node", tmpdir)

        with open(os.path.join(tmpdir, "discord_krisp.node"), "rb") as f:
            data = f.read()

        # ELF: check for MD5 comparison byte pattern (exactly 1 match)
        if data[:4] == b"\x7fELF":
            count = data.count(KRISP_PATCH_SIGNATURE)
            if count != 1:
                print(f"  WARNING: found {count} ELF signature matches (expected 1)")
                return False
            print("  Verified: ELF signature pattern found (1 unique match)")
            return True

        if ANCHOR_IMPORT in data:
            print("  Verified: Mach-O contains _SecStaticCodeCreateWithPath import")
            return True

        print("  WARNING: no patchable target found")
        return False


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

    for v in variants:
        platform, branch = v.platform, v.branch
        version = sources[serialize_variant(v)]["version"]
        print(
            f"Fetching krisp module for {platform.value}/{branch.value} (v{version})..."
        )

        try:
            krisp_url = fetch_krisp_module_url(branch, version, platform)
            if krisp_url is None:
                print(
                    f"  No krisp module available for {platform.value}/{branch.value}"
                )
                continue

            if not verify_krisp_patchable(krisp_url):
                print(
                    f"  WARNING: Krisp for {platform.value}/{branch.value} is NOT patchable, skipping"
                )
                continue

            krisp_hash = prefetch(krisp_url)
            sources[f"{serialize_variant(v)}-krisp"] = {
                "url": krisp_url,
                "version": krisp_url
                .rsplit("/", 1)[-1]
                .split("?")[0]
                .replace("discord_krisp-", "")
                .replace(".zip", ""),
                "hash": krisp_hash,
            }
            print(f"  OK: krisp for {platform.value}/{branch.value}")

        except Exception as exc:
            print(f"  Failed to fetch krisp for {platform.value}/{branch.value}: {exc}")

    with open(os.path.join(os.path.dirname(__file__), "sources.json"), "w") as f:
        json.dump(sources, f, indent=2, sort_keys=True)
        f.write("\n")


if __name__ == "__main__":
    main()
