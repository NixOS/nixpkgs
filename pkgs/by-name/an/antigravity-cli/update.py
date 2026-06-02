#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 lix jq

import re
import urllib.request
import json
import subprocess
import sys
import os
import tempfile
import hashlib

# Manifest sources from Google Antigravity release API
LATEST_VERSION_URL = "https://storage.googleapis.com/antigravity-public/antigravity-cli/latest"
MANIFEST_BASE = "https://storage.googleapis.com/antigravity-public/antigravity-cli"

# Mapping from Nixpkgs systems to Adriel's/Manifest's platform names
PLATFORM_MAP = {
    "x86_64-linux": "linux-x64",
    "aarch64-linux": "linux-arm",
    "x86_64-darwin": "darwin-x64",
    "aarch64-darwin": "darwin-arm",
}


def fetch_text(url):
    req = urllib.request.Request(
        url, headers={"User-Agent": "Mozilla/5.0"}
    )
    with urllib.request.urlopen(req) as response:
        return response.read().decode("utf-8").strip()


def fetch_json(url):
    return json.loads(fetch_text(url))


def get_nix_hash(url, expected_sha512):
    """Downloads, verifies sha512, unpacks, and returns the SRI hash of the directory content."""
    with tempfile.TemporaryDirectory() as tmpdir:
        archive_path = os.path.join(tmpdir, "archive.tar.gz")
        unpack_path = os.path.join(tmpdir, "unpack")
        os.makedirs(unpack_path)

        # Download
        print(f"  Downloading from {url}...")
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with (
            urllib.request.urlopen(req) as response,
            open(archive_path, "wb") as out_file,
        ):
            data = response.read()
            # 1. Integrity Check: Verify SHA512 against manifest
            actual_sha512 = hashlib.sha512(data).hexdigest()
            if actual_sha512 != expected_sha512:
                raise ValueError(f"SHA512 mismatch!\n  Expected: {expected_sha512}\n  Actual:   {actual_sha512}")
            
            out_file.write(data)

        # Unpack
        subprocess.run(["tar", "-xzf", archive_path, "-C", unpack_path], check=True)

        # 2. Sanity Check: Ensure the executable exists (Adriel's methodology)
        if not os.path.exists(os.path.join(unpack_path, "antigravity")):
            # Some platforms might have different names, check for it
            items = os.listdir(unpack_path)
            if "antigravity" not in items:
                raise FileNotFoundError(f"Expected executable 'antigravity' not found in archive. Found: {items}")

        # 3. Hash: Generate the nix directory hash
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

    # 1. Fetch the latest version string
    try:
        latest_version = fetch_text(LATEST_VERSION_URL)
    except Exception as e:
        print(f"Error fetching latest version: {e}", file=sys.stderr)
        sys.exit(1)

    # 2. Fetch the manifest for this version
    try:
        manifest = fetch_json(f"{MANIFEST_BASE}/{latest_version}/manifest.json")
    except Exception as e:
        print(f"Error fetching manifest for {latest_version}: {e}", file=sys.stderr)
        sys.exit(1)

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
        # Even if up to date, we can finish normally
        sys.exit(0)

    print(f"New version found! Updating: {current_version} -> {latest_version}")

    # 3. Update the version string in content
    content = re.sub(
        r'(version\s*=\s*")[^"]*(";)', f"\\g<1>{latest_version}\\g<2>", content
    )

    # 4. For each platform, fetch url and hash, and update sources
    for nix_system, manifest_platform in PLATFORM_MAP.items():
        print(f"Processing {nix_system} ({manifest_platform})...")
        
        platform_data = manifest.get("platforms", {}).get(manifest_platform)
        if not platform_data:
            print(f"Error: Platform {manifest_platform} not found in manifest", file=sys.stderr)
            sys.exit(1)

        url = platform_data["url"]
        expected_sha512 = platform_data["sha512"]
        
        try:
            sri_hash = get_nix_hash(url, expected_sha512)
        except Exception as e:
            print(f"Error processing {nix_system}: {e}", file=sys.stderr)
            sys.exit(1)

        # Regex to locate and replace URL and hash for this specific platform in package.nix
        pattern = rf'("{nix_system}"\s*=\s*\{{[^}}]+url\s*=\s*")[^"]*(";[^}}]+hash\s*=\s*")[^"]*(";)'
        replacement = f"\\g<1>{url}\\g<2>{sri_hash}\\g<3>"

        new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
        if new_content == content:
            print(f"Warning: Could not find/replace source block for {nix_system}")
        content = new_content

    # Write the updated content back
    with open(package_file, "w") as f:
        f.write(content)

    print(f"Successfully updated package.nix to version {latest_version}!")


if __name__ == "__main__":
    main()
