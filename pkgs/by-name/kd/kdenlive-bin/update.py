#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 common-updater-scripts

import re
import subprocess
import urllib.request

# Git tags include betas in the same version scheme which seems error prone to filter out
# Easier to get the info from here
BASE = "https://download.kde.org/stable/kdenlive"

# e.g "26.04/"
SERIES = re.compile(r'href="(\d+\.\d+)/"')

# Ignore variant artifacts, e.g "kdenlive-26.04.0-A-arm64.dmg"
IMAGE = re.compile(r"kdenlive-(\d+(?:\.\d+)*)-arm64\.dmg")


def fetch(url):
    with urllib.request.urlopen(url) as response:
        return response.read().decode()


def newest(pattern, url, what):
    found = set(pattern.findall(fetch(url)))
    if not found:
        raise SystemExit(f"found no {what} at {url}")
    return max(found, key=lambda v: tuple(int(n) for n in v.split(".")))


def main():
    series = newest(SERIES, f"{BASE}/", "release series")
    macos = f"{BASE}/{series}/macOS/"
    version = newest(IMAGE, macos, "macOS disk image")
    subprocess.run(["update-source-version", "kdenlive-bin", version],
                   check=True)


if __name__ == "__main__":
    main()
