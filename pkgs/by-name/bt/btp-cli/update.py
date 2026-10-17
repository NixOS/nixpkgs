#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.requests ])"
import hashlib
import json
import os
import pathlib
import re
import sys

import requests

URL = "https://tools.hana.ondemand.com"
PACKAGE_NAME = "btp-cli"

VERSION_PATTERN = re.compile(
    r"btp-cli-(?:linux|darwin)-(?:arm|amd)64-(\d+\.\d+\.\d+).tar.gz"
)

response = requests.get(URL)
text = response.text

VERSION = max(
    list(set(VERSION_PATTERN.findall(text))),
    key=lambda v: tuple(map(int, v.split("."))),
)

with open(
    os.path.join(pathlib.Path(__file__).parent, "manifest.json"),
    "r",
    encoding="utf-8",
) as f:
    manifest_data = json.load(f)

if manifest_data["version"] == VERSION:
    print(f"Package {PACKAGE_NAME} is already up to date.")
    sys.exit(0)

manifest_data["version"] = VERSION

DOWNLOAD_BASE_URL = f"{URL}/additional"

DARWIN_ARM64_DOWNLOAD_URL = f"{DOWNLOAD_BASE_URL}/btp-cli-darwin-arm64-{VERSION}.tar.gz"
DARWIN_X64_DOWNLOAD_URL = f"{DOWNLOAD_BASE_URL}/btp-cli-darwin-amd64-{VERSION}.tar.gz"
LINUX_ARM64_DOWNLOAD_URL = f"{DOWNLOAD_BASE_URL}/btp-cli-linux-arm64-{VERSION}.tar.gz"
LINUX_X64_DOWNLOAD_URL = f"{DOWNLOAD_BASE_URL}/btp-cli-linux-amd64-{VERSION}.tar.gz"

DARWIN_ARM64_SHA1_URL = f"{DARWIN_ARM64_DOWNLOAD_URL}.sha1"
DARWIN_X64_SHA1_URL = f"{DARWIN_X64_DOWNLOAD_URL}.sha1"
LINUX_ARM64_SHA1_URL = f"{LINUX_ARM64_DOWNLOAD_URL}.sha1"
LINUX_X64_SHA1_URL = f"{LINUX_X64_DOWNLOAD_URL}.sha1"

PLATFORMS = {
    "aarch64-darwin": {
        "download_url": DARWIN_ARM64_DOWNLOAD_URL,
        "hash": DARWIN_ARM64_SHA1_URL,
    },
    "aarch64-linux": {
        "download_url": LINUX_ARM64_DOWNLOAD_URL,
        "hash": LINUX_ARM64_SHA1_URL,
    },
    "x86_64-darwin": {
        "download_url": DARWIN_X64_DOWNLOAD_URL,
        "hash": DARWIN_X64_SHA1_URL,
    },
    "x86_64-linux": {
        "download_url": LINUX_X64_DOWNLOAD_URL,
        "hash": LINUX_X64_SHA1_URL,
    },
}

for platform, data in PLATFORMS.items():
    download_url = data["download_url"]
    hash_value_url = data["hash"]

    cookies = {"eula_3_2_agreed": "tools.hana.ondemand.com/developer-license-3_2.txt"}

    response = requests.get(download_url, cookies=cookies)
    download_sha1 = hashlib.sha1(response.content).hexdigest()
    download_sha256 = hashlib.sha256(response.content).hexdigest()

    response = requests.get(hash_value_url)
    sha1 = response.text.strip()

    if download_sha1 != sha1:
        print(f"SHA1 mismatch for {platform}: {download_sha1} != {sha1}")
        manifest_data["platforms"][platform] = {}
        continue

    manifest_data["platforms"][platform] = {
        "url": download_url,
        "hash": download_sha256,
    }

with open(
    os.path.join(pathlib.Path(__file__).parent, "manifest.json"),
    "w",
    encoding="utf-8",
) as f:
    f.write(json.dumps(manifest_data, indent=2) + "\n")
