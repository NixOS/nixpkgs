#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix jq

import re
import urllib.request
import json
import subprocess
import sys
import os
import tempfile

MANIFEST_BASE = (
    "https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests"
)
PLATFORMS = {
    "x86_64-linux": "linux_amd64",
    "aarch64-linux": "linux_arm64",
    "x86_64-darwin": "darwin_amd64",
    "aarch64-darwin": "darwin_arm64",
}


def fetch_json(url):
    req = urllib.request.Request(
        url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    )
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode("utf-8"))


def get_nix_hash(url):
    """Downloads, unpacks, and returns the SRI hash of the directory content."""
    with tempfile.TemporaryDirectory() as tmpdir:
        archive_path = os.path.join(tmpdir, "archive.tar.gz")
        unpack_path = os.path.join(tmpdir, "unpack")
        os.makedirs(unpack_path)

        # Download
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with (
            urllib.request.urlopen(req) as response,
            open(archive_path, "wb") as out_file,
        ):
            out_file.write(response.read())

        # Unpack
        subprocess.run(["tar", "-xzf", archive_path, "-C", unpack_path], check=True)

        # Hash
        result = subprocess.run(
            ["nix", "hash", "path", "--type", "sha256", unpack_path],
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.strip()


def main():
    # Change directory to the script's directory so paths are relative
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)

    print("Checking for updates from Google Antigravity release API...")

    # 1. Fetch the latest version from the linux_amd64 manifest
    try:
        manifest = fetch_json(f"{MANIFEST_BASE}/linux_amd64.json")
    except Exception as e:
        print(f"Error fetching manifest: {e}", file=sys.stderr)
        sys.exit(1)

    latest_version = manifest["version"]

    # Read the current package.nix
    package_file = "package.nix"
    if not os.path.exists(package_file):
        print(f"Error: Could not find package.nix in {script_dir}", file=sys.stderr)
        sys.exit(1)

    with open(package_file, "r") as f:
        content = f.read()

    # Extract current version
    version_match = re.search(r'version\s*=\s*"([^"]*)"', content)
    if not version_match:
        print(
            "Error: Could not parse current version from package.nix", file=sys.stderr
        )
        sys.exit(1)

    current_version = version_match.group(1)

    if current_version == latest_version:
        print(f"Already up to date (current version {current_version} is the latest).")
        sys.exit(0)

    print(f"New version found! Updating: {current_version} -> {latest_version}")

    # 2. Update the version string in content
    content = re.sub(
        r'(version\s*=\s*")[^"]*(";)', f"\\g<1>{latest_version}\\g<2>", content
    )

    # 3. For each platform, fetch url and hash, and update sources
    for platform, manifest_name in PLATFORMS.items():
        print(f"Fetching manifest for {platform}...")
        try:
            m = fetch_json(f"{MANIFEST_BASE}/{manifest_name}.json")
        except Exception as e:
            print(f"Error fetching manifest for {platform}: {e}", file=sys.stderr)
            sys.exit(1)

        url = m["url"]
        sri_hash = get_nix_hash(url)

        # Regex to locate and replace URL and hash for this specific platform in package.nix
        pattern = rf'("{platform}"\s*=\s*\{{[^}}]+url\s*=\s*")[^"]*(";[^}}]+hash\s*=\s*")[^"]*(";)'
        replacement = f"\\g<1>{url}\\g<2>{sri_hash}\\g<3>"

        content = re.sub(pattern, replacement, content)

    # Write the updated content back
    with open(package_file, "w") as f:
        f.write(content)

    print(f"Successfully updated package.nix to version {latest_version}!")


if __name__ == "__main__":
    main()
