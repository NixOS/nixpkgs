#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p python3 curl common-updater-scripts nix coreutils

"""
Updater script for the roon-server package.
"""

import subprocess
import urllib.request
import re
import sys
import os


def get_current_version():
    """Get the current version of roon-server from the package.nix file."""
    result = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "-E",
            "with import ./. {}; roon-server.version or (lib.getVersion roon-server)",
        ],
        capture_output=True,
        text=True,
    )
    result.check_returncode()
    return result.stdout.strip().strip('"')


def get_latest_version_info():
    """Get the latest version information from the Roon Labs API."""
    url = "https://updates.roonlabs.net/update/?v=2&platform=linux&version=&product=RoonServer&branding=roon&branch=production&curbranch=production"
    with urllib.request.urlopen(url) as response:
        content = response.read().decode("utf-8")

        # Parse the response
        info = {}
        for line in content.splitlines():
            if "=" in line:
                key, value = line.split("=", 1)
                info[key] = value

        return info


def parse_version(display_version):
    """Parse the display version string to get the version in the format used in the package.nix file."""
    # Example: "2.47 (build 1510) production" -> "2.47.1510"
    match = re.search(r"(\d+\.\d+)\s+\(build\s+(\d+)\)", display_version)
    if match:
        return f"{match.group(1)}.{match.group(2)}"
    return None


def get_hash(url):
    """Calculate the hash of the package."""
    result = subprocess.run(
        ["nix-prefetch-url", "--type", "sha256", url], capture_output=True, text=True
    )
    result.check_returncode()
    pkg_hash = result.stdout.strip()

    result = subprocess.run(
        ["nix", "hash", "to-sri", f"sha256:{pkg_hash}"], capture_output=True, text=True
    )
    result.check_returncode()
    return result.stdout.strip()


def update_package(new_version, hash_value):
    """Update the package.nix file with the new version and hash."""
    subprocess.run(
        [
            "update-source-version",
            "roon-server",
            new_version,
            hash_value,
            "--ignore-same-version",
        ],
        check=True,
    )


def main():
    current_version = get_current_version()
    print(f"Current roon-server version: {current_version}")

    try:
        latest_info = get_latest_version_info()

        display_version = latest_info.get("displayversion", "")
        download_url = latest_info.get("updateurl", "")

        if not display_version or not download_url:
            print("Error: Failed to get version information from Roon Labs API")
            sys.exit(1)

        print(f"Latest version from API: {display_version}")
        print(f"Download URL: {download_url}")

        new_version = parse_version(display_version)
        if not new_version:
            print(
                f"Error: Failed to parse version from display version: {display_version}"
            )
            sys.exit(1)

        print(f"Parsed version: {new_version}")

        if new_version == current_version:
            print("roon-server is already up to date!")
            return

        print(f"Calculating hash for new version {new_version}...")
        hash_value = get_hash(download_url)

        print(
            f"Updating package.nix with new version {new_version} and hash {hash_value}"
        )
        update_package(new_version, hash_value)

        print(f"Successfully updated roon-server to version {new_version}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
