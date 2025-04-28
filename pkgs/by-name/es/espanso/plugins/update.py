#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.packaging python3Packages.pyyaml python3Packages.requests nix
#
# format:
# $ nix run nixpkgs#python3Packages.ruff -- format update.py

import os
import re
import argparse
import sys
import subprocess
import pathlib
import functools

import requests
import json
import base64
import yaml
from packaging import version

from typing import Optional, Any

ESPANSO_HUB_API_URL = "https://api.github.com/repos/espanso/hub"
ESPANSO_HUB_URL = "https://github.com/espanso/hub"


def get_github_headers() -> dict[str, str]:
    """Create headers for GitHub API requests"""
    headers = {"Accept": "application/vnd.github.v3+json"}
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        headers["Authorization"] = f"Bearer {github_token}"
    headers["X-GitHub-Api-Version"] = "2022-11-28"

    return headers


def fetch_hub_packages(headers: dict[str, str]) -> list[str]:
    """Fetch all packages on the hub."""
    packages_dir_url = f"{ESPANSO_HUB_API_URL}/contents/packages"

    try:
        response = requests.get(packages_dir_url, headers=headers)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"Error fetching packages: {e}")
        return []
    else:
        package_dirs_json = json.loads(response.text)
        return [str(package["name"]) for package in package_dirs_json]


def fetch_license_file(package: str, version: str, headers: dict[str, str]) -> str:
    """Fetch the `LICENSE` file."""
    packages_dir_url = (
        f"{ESPANSO_HUB_API_URL}/contents/packages/{package}/{version}/LICENSE"
    )

    try:
        response = requests.get(packages_dir_url, headers=headers)
        response.raise_for_status()
    except requests.RequestException:
        raise FileNotFoundError
    else:
        license_json = json.loads(response.text)
        return str(base64.b64decode(license_json["content"]))


def fetch_package_version_from_dir(
    package: str, headers: dict[str, str]
) -> Optional[str]:
    """Fetch the package version from within the package directory."""
    package_dir_url = f"{ESPANSO_HUB_API_URL}/contents/packages/{package}"

    response = requests.get(package_dir_url, headers=headers)
    response.raise_for_status()
    version_dirs_json = json.loads(response.text)
    if re.match(r"^\d+\.\d+\.\d+$", str(version_dirs_json[-1]["name"])):
        return str(version_dirs_json[-1]["name"])
    else:
        return None


def fetch_new_revision(branch: str, headers: dict[str, str]) -> str:
    package_manifest_url = f"{ESPANSO_HUB_API_URL}/branches/{branch}"

    response = requests.get(package_manifest_url, headers=headers)
    response.raise_for_status()
    branch_json = json.loads(response.text)
    return str(branch_json["commit"]["sha"])


def fetch_package_manifest(package: str, version: str, headers: dict[str, str]) -> Any:
    """Fetch the package manifest from espanso/hub."""
    package_manifest_url = (
        f"{ESPANSO_HUB_API_URL}/contents/packages/{package}/{version}/_manifest.yml"
    )

    response = requests.get(package_manifest_url, headers=headers)
    response.raise_for_status()
    package_manifest_json = json.loads(response.text)
    package_manifest_content = base64.b64decode(package_manifest_json["content"])
    return yaml.safe_load(package_manifest_content)


def get_package_nix_path(package: str) -> str:
    """Get the path to the packages nix file."""
    return f"{os.getcwd()}/pkgs/by-name/es/espanso/plugins/{package}/default.nix"


def exec(cmd: str, capture_output: bool = True) -> str:
    """Execute a shell command and return its output"""
    result = subprocess.run(
        cmd, shell=True, text=True, capture_output=capture_output, check=True
    )
    return result.stdout.strip() if capture_output else ""


def get_current_package_version(package: str) -> version.Version:
    """Get the current version of the espanso package packaged in nixpkgs."""
    return version.Version(
        exec(f'nix eval --raw -f {os.getcwd()} espansoPlugins."{package}".version')
    )


def read_nix_file(file_path: str) -> str:
    """Read the content of a Nix file"""
    with open(file_path, "r") as f:
        return f.read()


def write_nix_file(file_path: str, content: str) -> None:
    """Write content to a Nix file"""
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w") as f:
        _ = f.write(content)


def calculate_sri_hash(url: str, rev: str) -> str:
    """Calculate the SRI hash of the source"""
    prefetch_url = f"{url}/archive/{rev}.tar.gz"

    new_hash = exec(
        f"nix-prefetch-url --unpack --type sha256 {prefetch_url} 2>/dev/null"
    )

    # If the hash is not in SRI format, convert it
    if not new_hash.startswith("sha256-"):
        # Try to convert the hash to SRI format
        new_hash = exec(f"nix hash to-sri --type sha256 {new_hash} 2>/dev/null")

        # If that fails, try another approach
        if not new_hash.startswith("sha256-"):
            print(
                "Warning: Failed to get SRI hash directly, trying alternative method..."
            )
            raw_hash = exec(
                f"nix-prefetch-url --type sha256 {prefetch_url} 2>/dev/null"
            )
            new_hash = exec(f"nix hash to-sri --type sha256 {raw_hash} 2>/dev/null")

    # Verify we got a valid SRI hash
    if not new_hash.startswith("sha256-"):
        print(f"Error: Failed to generate valid SRI hash. Output was: {new_hash}")
        sys.exit(1)

    return new_hash


def update_version(content: str, version: str) -> str:
    """Update the version within a Nix file."""
    if "version = " in content:
        return re.sub(r'version = "[^"]*"', f'version = "{version}"', content)
    else:
        return re.sub(r'(pname = "[^"]*";)', f'\\1\n  version = "{version}";', content)


def update_rev(content: str, rev: str) -> str:
    """Update the revision within a Nix file."""
    return re.sub(r'rev = "[^"]*"', f'rev = "{rev}"', content)


def update_hash(content: str, hash: str) -> str:
    """Update the hash within a Nix file."""
    if 'hash = "' in content:
        return re.sub(r'hash = "[^"]*"', f'hash = "{hash}"', content)
    elif "fetchFromGitHub" in content:
        return re.sub(r'sha256 = "[^"]*"', f'sha256 = "{hash}"', content)
    else:
        print("Error: Could not find hash attribute")
        sys.exit(1)


def escape(input: str) -> str:
    """Escape characters and character sequences that would break a string in Nix."""
    output = input
    output = output.replace("\\", "\\\\")
    output = output.replace('"', '\\"')
    output = output.replace("${", "''${")
    return output


def update_metadata(content: str, package_manifest: Any) -> str:
    """Update the metadata within a Nix file."""
    new_content = content
    if 'description = "' in content:
        new_content = re.sub(
            r'description = "[^"]*"',
            f'description = "{escape(package_manifest["description"])}"',
            new_content,
        )
    if 'homepage = "' in content and "homepage" in package_manifest.keys():
        new_content = re.sub(
            r'homepage = "[^"]*"',
            f'homepage = "{escape(package_manifest["homepage"])}"',
            new_content,
        )
    return new_content


def update_nix_file(
    package: str,
    rev: str,
    hash: str,
    package_manifest: Any,
    commit_changes: bool = False,
) -> None:
    """Update the nix file of the package."""
    package_nix_file = get_package_nix_path(package)
    current_version = get_current_package_version(package)
    new_version = version.Version(package_manifest["version"])

    if current_version < new_version:
        print(f"Updating {package}: {current_version} -> {new_version} ({rev})")

        content = read_nix_file(package_nix_file)
        content = update_version(content, new_version)
        content = update_rev(content, rev)
        content = update_hash(content, hash)
        content = update_metadata(content, package_manifest)

        write_nix_file(package_nix_file, content)

        if commit_changes:
            commit_package(
                package, f"espansoPlugins.{package}: {current_version} -> {new_version}"
            )


def create_nix_file(
    package: str,
    rev: str,
    hash: str,
    package_manifest: Any,
    maintainers: list[str],
    commit_changes: bool = False,
) -> None:
    """Create a new nix file for the package."""
    package_nix_file = get_package_nix_path(package)

    print(
        f"Creating {package} {package_manifest['version']} ({rev}) - Please add the `meta.license` attribute manually"
    )
    content = [
        "{",
        "  lib,",
        "  fetchFromGitHub,",
        "  mkEspansoPlugin,",
        "}:",
        "mkEspansoPlugin {",
        f'  pname = "{package}";',
        f'  version = "{package_manifest["version"]}";',
        "",
        "  src = fetchFromGitHub {",
        '    owner = "espanso";',
        '    repo = "hub";',
        f'    rev = "{rev}";',
        f'    hash = "{hash}";',
        "  };",
        "",
        "  meta = {",
        f'    description = "{escape(package_manifest["description"])}";',
        *(
            [f'    homepage = "{escape(package_manifest["homepage"])}";']
            if "homepage" in package_manifest.keys()
            else []
        ),
        f"    maintainers = with lib.maintainers; [ {str.join(' ', maintainers)} ];",
        "  };",
        "}",
    ]

    write_nix_file(package_nix_file, str.join("\n", content))

    if commit_changes:
        commit_package(
            package, f"espansoPlugins.{package}: init at {package_manifest['version']}"
        )


def commit_package(package: str, message: str) -> None:
    """Commit the package file with given commit message."""
    package_nix_file = get_package_nix_path(package)
    _ = exec(f"git add {package_nix_file}", capture_output=False)
    _ = exec("nix fmt", capture_output=False)
    _ = exec(f'git commit -m "{escape(message)}"', capture_output=False)
    # _ = exec("jj new", capture_output=False)
    # _ = exec(f"jj file track {package_nix_file}", capture_output=False)
    # _ = exec("nix fmt", capture_output=False)
    # _ = exec(f'jj describe -m "{escape(message)}"', capture_output=False)


def main(
    packages: Optional[list[str]],
    maintainers: list[str],
    commit_changes: bool,
) -> None:
    """Main function to update an Espanso package"""
    gh_headers = get_github_headers()

    packages = packages or fetch_hub_packages(gh_headers)
    rev = fetch_new_revision("main", gh_headers)
    hash = calculate_sri_hash(ESPANSO_HUB_URL, rev)

    for package in packages:
        version = fetch_package_version_from_dir(package, gh_headers)
        if version is None:
            print(f"Skipping '{package}' because it contains no version directory")
        else:
            package_manifest = fetch_package_manifest(package, version, gh_headers)

            package_nix_file = get_package_nix_path(package)
            if pathlib.Path(package_nix_file).exists():
                try:
                    update_nix_file(
                        package, rev, hash, package_manifest, commit_changes
                    )
                except Exception as e:
                    print(f"Failed to update '{package}': {e}")
                    break

            else:
                try:
                    create_nix_file(
                        package,
                        rev,
                        hash,
                        package_manifest,
                        maintainers,
                        commit_changes,
                    )
                except Exception as e:
                    print(f"Failed to create '{package}': {e}")
                    break


parser = argparse.ArgumentParser(description="Update Espanso packages")
_ = parser.add_argument(
    "--commit-changes",
    action="store_true",
    help="Automatically commit changes with the according commit message",
)
_ = parser.add_argument(
    "--maintainers",
    type=str,
    help="A comma separated list of maintainers which will be added to newly created packages.",
)
_ = parser.add_argument(
    "packages",
    nargs="*",
    help="A list of package names to update. If no package names are specified, all packages from `github:espanso/hub/packages/ <https://github.com/espanso/hub/packages>`_ will be updated.",
)

if __name__ == "__main__":
    args = parser.parse_args()
    maintainers = []
    if args.maintainers is not None:
        maintainers = [s.strip() for s in args.maintainers.split(",")]

    try:
        main(args.packages, maintainers, args.commit_changes)
    except KeyboardInterrupt as e:
        # Let’s cancel outside of the main loop too.
        sys.exit(130)
