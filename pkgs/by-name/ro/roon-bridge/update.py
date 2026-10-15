#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p python3 curl common-updater-scripts nix coreutils

"""
Updater script for the roon-bridge package.
"""

import subprocess
import urllib.request
import re
import sys
import os


PACKAGE_NIX = os.path.join(os.path.dirname(os.path.abspath(__file__)), "package.nix")


def get_current_version():
    """Get the current version of roon-bridge from the package.nix file."""
    env_version = os.environ.get("UPDATE_NIX_OLD_VERSION")
    if env_version:
        return env_version
    attr = os.environ.get("UPDATE_NIX_ATTR_PATH", "roon-bridge")
    result = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "-E",
            f"with import ./. {{}}; {attr}.version or (lib.getVersion {attr})",
        ],
        capture_output=True,
        text=True,
    )
    result.check_returncode()
    return result.stdout.strip().strip('"')


def get_latest_version_info():
    """Get the latest version information from the Roon Labs API."""
    url = "https://updates.roonlabs.net/update/?v=2&platform=linux&version=&product=RoonBridge&branding=roon&branch=production&curbranch=production"
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
    # Example: "2.60 (build 1501) production" -> "2.60.1501"
    match = re.search(r"(\d+\.\d+)\s+\(build\s+(\d+)\)", display_version)
    if match:
        return f"{match.group(1)}.{match.group(2)}"
    return None


def get_download_url(version, system):
    """Construct the download URL for the given version and system."""
    url_version = version.replace(".", "0")
    return f"https://download.roonlabs.com/updates/production/RoonBridge_{system}_{url_version}.tar.bz2"


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


def update_package(new_version, hash_x64, hash_arm64):
    """Update the package.nix file with the new version and hashes."""
    with open(PACKAGE_NIX) as f:
        content = f.read()

    content = re.sub(r'version = "[^"]+"', f'version = "{new_version}"', content)
    content = re.sub(
        r'("linuxx64" then\s+)"sha256-[^"]+"',
        rf'\1"{hash_x64}"',
        content,
    )
    content = re.sub(
        r'("linuxarmv8" then\s+)"sha256-[^"]+"',
        rf'\1"{hash_arm64}"',
        content,
    )

    with open(PACKAGE_NIX, "w") as f:
        f.write(content)


def main():
    current_version = get_current_version()
    print(f"Current roon-bridge version: {current_version}")

    try:
        latest_info = get_latest_version_info()

        display_version = latest_info.get("displayversion", "")

        if not display_version:
            print("Error: Failed to get version information from Roon Labs API")
            sys.exit(1)

        print(f"Latest version from API: {display_version}")

        new_version = parse_version(display_version)
        if not new_version:
            print(
                f"Error: Failed to parse version from display version: {display_version}"
            )
            sys.exit(1)

        print(f"Parsed version: {new_version}")

        if new_version == current_version:
            print("roon-bridge is already up to date!")
            return

        url_x64 = get_download_url(new_version, "linuxx64")
        url_arm64 = get_download_url(new_version, "linuxarmv8")

        print(f"Calculating hash for x86_64 ({url_x64})...")
        hash_x64 = get_hash(url_x64)

        print(f"Calculating hash for aarch64 ({url_arm64})...")
        hash_arm64 = get_hash(url_arm64)

        print(f"Updating package.nix with new version {new_version}")
        update_package(new_version, hash_x64, hash_arm64)

        print(f"Successfully updated roon-bridge to version {new_version}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
