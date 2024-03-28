"""
If you make any changes please make sure to format the file with
"black" https://github.com/psf/black, you do that by running
black discord-updater.py
"""

import requests
import re
import os
import json

PLATFORM_LINUX = "x86_64-linux"
PLATFORM_OSX = "x86_64-darwin"
VERSION_PATTERN = r"/(\d+\.\d+\.\d+)"

osx_links = {
    "stable": "https://discord.com/api/download?platform=osx",
    "ptb": "https://discord.com/api/download/ptb?platform=osx",
    "canary": "https://discord.com/api/download/canary?platform=osx",
    "development": "https://discord.com/api/download/development?platform=osx",
}

linux_links = {
    "stable": "https://discord.com/api/download?platform=linux&format=tar.gz",
    "ptb": "https://discord.com/api/download/ptb?platform=linux&format=tar.gz",
    "canary": "https://discord.com/api/download/canary?platform=linux&format=tar.gz",
    "development": "https://discord.com/api/download/development?platform=linux&format=tar.gz",
}

platforms = [(PLATFORM_LINUX, linux_links), (PLATFORM_OSX, osx_links)]


# This is not an ideal way to do this, but I'm not aware of a better way
# BUT if you know a better way to do this, please make a PR
def fetch_old_version(branch, platform):
    with open("./default.nix", "r") as f:
        content = f.read()
    # e.g: stable = "0.0.46";
    pattern = re.compile(rf'{branch} = "(\d+\.\d+\.\d+)";')
    if platform == PLATFORM_LINUX:
        start_delimiter = "then {"
        end_delimiter = "} else"
    else:
        start_delimiter = "} else {"
        end_delimiter = "};"

    # Extract the section of the content for the given platform
    # We split the content on the start delimiter and take the second part ([1])
    # Then we split that part on the end delimiter and take the first part ([0])
    content = content.split(start_delimiter)[1].split(end_delimiter)[0]
    match = re.search(pattern, content)
    return match.group(1) if match else None


def fetch_latest_version(branch_url):
    # HEAD request to follow the redirect WITHOUT downloading, so we can get latest version
    response = requests.head(branch_url, allow_redirects=True)
    if response.status_code != 200:
        raise ValueError(
            f"Request to {branch_url} failed with status code {response.status_code}"
        )
    match = re.search(VERSION_PATTERN, response.url)
    if match:
        return response.url, match.group(1)
    else:
        raise ValueError(f"No match found in URL {response.url}")


for platform, links in platforms:
    print(f"\n## Checking updates for {platform} ##\n")
    for branch, link in links.items():
        old_version = fetch_old_version(branch, platform)
        new_version_url, new_version = fetch_latest_version(link)

        if old_version != new_version:
            result = os.popen(
                f"nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 {new_version_url}"
            ).read()
            sha256_hash = json.loads(result)["hash"]
            if branch == "stable":
                print(f"discord: {old_version} -> {new_version} ({sha256_hash})")
            else:
                print(
                    f"discord-{branch}: {old_version} -> {new_version} ({sha256_hash})"
                )
        else:
            if branch == "stable":
                print(f"No new version for discord. Current version: {old_version}")
            else:
                print(
                    f"No new version for discord-{branch}. Current version: {old_version}"
                )

