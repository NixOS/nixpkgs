#!/usr/bin/env python3

import hashlib
import multiprocessing as mp
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

import requests
from requests.adapters import HTTPAdapter, Retry

from common import eprint, load_toml, get_lockfile_version, parse_git_source


def download_file_with_checksum(url: str, destination_path: Path) -> str:
    retries = Retry(
        total=5,
        backoff_factor=0.5,
        status_forcelist=[500, 502, 503, 504]
    )
    session = requests.Session()
    session.mount('http://', HTTPAdapter(max_retries=retries))
    session.mount('https://', HTTPAdapter(max_retries=retries))

    sha256_hash = hashlib.sha256()
    with session.get(url, stream=True) as response:
        if not response.ok:
            raise Exception(f"Failed to fetch file from {url}. Status code: {response.status_code}")
        with open(destination_path, "wb") as file:
            for chunk in response.iter_content(1024):  # Download in chunks
                if chunk:  # Filter out keep-alive chunks
                    file.write(chunk)
                    sha256_hash.update(chunk)

    # Compute the final checksum
    checksum = sha256_hash.hexdigest()
    return checksum


def get_download_url_for_tarball(pkg: dict[str, Any]) -> str:
    # TODO: support other registries
    #       maybe fetch config.json from the registry root and get the dl key
    #       See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
    if pkg["source"] != "registry+https://github.com/rust-lang/crates.io-index":
        raise Exception("Only the default crates.io registry is supported.")

    return f"https://crates.io/api/v1/crates/{pkg["name"]}/{pkg["version"]}/download"


def download_tarball(pkg: dict[str, Any], out_dir: Path) -> None:

    url = get_download_url_for_tarball(pkg)
    filename = f"{pkg["name"]}-{pkg["version"]}.tar.gz"

    # TODO: allow legacy checksum specification, see importCargoLock for example
    #       also, don't forget about the other usage of the checksum
    expected_checksum = pkg["checksum"]

    tarball_out_dir = out_dir / "tarballs" / filename
    eprint(f"Fetching {url} -> tarballs/{filename}")

    calculated_checksum = download_file_with_checksum(url, tarball_out_dir)

    if calculated_checksum != expected_checksum:
        raise Exception(f"Hash mismatch! File fetched from {url} had checksum {calculated_checksum}, expected {expected_checksum}.")


def download_git_tree(url: str, git_sha_rev: str, out_dir: Path) -> None:

    tree_out_dir = out_dir / "git" / git_sha_rev
    eprint(f"Fetching {url}#{git_sha_rev} -> git/{git_sha_rev}")

    cmd = ["nix-prefetch-git", "--builder", "--quiet", "--fetch-submodules", "--url", url, "--rev", git_sha_rev, "--out", str(tree_out_dir)]
    subprocess.check_output(cmd)


def create_vendor_staging(lockfile_path: Path, out_dir: Path) -> None:
    cargo_lock_toml = load_toml(lockfile_path)
    lockfile_version = get_lockfile_version(cargo_lock_toml)

    git_packages: list[dict[str, Any]] = []
    registry_packages: list[dict[str, Any]] = []

    for pkg in cargo_lock_toml["package"]:
        # ignore local dependenices
        if "source" not in pkg.keys():
            eprint(f"Skipping local dependency: {pkg["name"]}")
            continue
        source = pkg["source"]

        if source.startswith("git+"):
            git_packages.append(pkg)
        elif source.startswith("registry+"):
            registry_packages.append(pkg)
        else:
            raise Exception(f"Can't process source: {source}.")

    git_sha_rev_to_url: dict[str, str] = {}
    for pkg in git_packages:
        source_info = parse_git_source(pkg["source"], lockfile_version)
        git_sha_rev_to_url[source_info["git_sha_rev"]] = source_info["url"]

    out_dir.mkdir(exist_ok=True)
    shutil.copy(lockfile_path, out_dir / "Cargo.lock")

    # fetch git trees sequentially, since fetching concurrently leads to flaky behaviour
    if len(git_packages) != 0:
        (out_dir / "git").mkdir()
        for git_sha_rev, url in git_sha_rev_to_url.items():
            download_git_tree(url, git_sha_rev, out_dir)

    # run tarball download jobs in parallel, with at most 5 concurrent download jobs
    with mp.Pool(min(5, mp.cpu_count())) as pool:
        if len(registry_packages) != 0:
            (out_dir / "tarballs").mkdir()
            tarball_args_gen = ((pkg, out_dir) for pkg in registry_packages)
            pool.starmap(download_tarball, tarball_args_gen)


def main() -> None:
    create_vendor_staging(lockfile_path=Path(sys.argv[1]), out_dir=Path(sys.argv[2]))

if __name__ == "__main__":
    main()
