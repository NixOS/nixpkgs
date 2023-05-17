#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.packaging
import base64
from pathlib import Path
import sys
from urllib import request
from http.client import HTTPResponse
from re import compile
import textwrap

from packaging.version import Version, InvalidVersion

# Name -> channel root
CHANNELS: dict[str, str] = {
    "stable": "opera/desktop",
    "beta": "opera-beta",
    "developer": "opera-developer",
}

MIRROR_URL = "https://get.geo.opera.com/pub"

# versions expected to be > 5 characters
VERSION_EXTRACTOR = compile(r'.*href="([\d\.]{5,})/"')


def get_latest_version(channel_root: str) -> Version:
    # Mirror returns an autoindex of the directory tree.
    # Parses the version numbers from the names of the subdirectories.
    url = f"{MIRROR_URL}/{channel_root}/"
    handle: HTTPResponse
    version = Version("0.0.0")
    with request.urlopen(url=url) as handle:
        for line in handle.readlines():
            raw_version = VERSION_EXTRACTOR.match(line.decode())
            if raw_version:
                try:
                    new_version = Version(raw_version.group(1))
                except InvalidVersion:
                    continue
                if new_version > version:
                    version = new_version
    return version


def get_version_sha256(channel: str, channel_root: str, version: str) -> str:
    pkg = f"opera-{channel}_{version}_amd64.deb"
    url = f"{MIRROR_URL}/{channel_root}/{version}/linux/{pkg}.sha256sum"
    handle: HTTPResponse
    with request.urlopen(url=url) as handle:
        sha256sum = handle.read().decode().strip()
        return "sha256-" + base64.b64encode(bytes.fromhex(sha256sum)).decode("ascii")


def generate_nix(
    channel: str,
    channel_root: str,
    version: Version,
    sha256sum: str,
) -> str:
    return textwrap.dedent(
        f"""\
        {channel} = import ./browser.nix {{
          channel = "{channel}";
          channelRoot = "{channel_root}";
          version = "{version}";
          sha256 = "{sha256sum}";
        }};"""
    )


def main() -> int:
    output: list[str] = ["{"]
    for channel, channel_root in CHANNELS.items():
        version = get_latest_version(channel_root)
        sha256sum = get_version_sha256(channel, channel_root, str(version))
        print(channel, version, sha256sum)
        output.append(
            textwrap.indent(
                generate_nix(channel, channel_root, version, sha256sum), "  "
            ),
        )
    Path("default.nix").write_text("\n".join(output) + "\n}\n", newline="\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
