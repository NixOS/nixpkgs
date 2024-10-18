import functools
import glob
import hashlib
import json
import multiprocessing as mp
import os
import re
import shutil
import subprocess
import sys

import requests
import tomli


eprint = functools.partial(print, file=sys.stderr)


def load_toml(path: str) -> dict:
    with open(path, "rb") as f:
        return tomli.load(f)


def download_file_with_checksum(url: str, destination_path: str, expected_checksum: str):
    """Downloads a file and computes its SHA-256 checksum while writing it to disk."""
    sha256_hash = hashlib.sha256()
    with requests.get(url, stream=True) as response:
        if not response.ok:
            raise Exception(f"Failed to download file from {url}. Status code: {response.status_code}")
        with open(destination_path, "wb") as file:
            for chunk in response.iter_content(1024):  # Download in chunks
                if chunk:  # Filter out keep-alive chunks
                    file.write(chunk)
                    sha256_hash.update(chunk)

    # Compute the final checksum
    calculated_checksum = sha256_hash.hexdigest()

    if calculated_checksum != expected_checksum:
        raise Exception(f"Hash mismatch! File fetched from {url} had checksum {calculated_checksum}, expected {expected_checksum}.")


def get_download_url_for_tarball(pkg: dict):
    # TODO: support other registries
    #       maybe fetch config.json from the registry root and get the dl key
    #       See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
    if pkg["source"] != "registry+https://github.com/rust-lang/crates.io-index":
        raise Exception("Only the default crates.io registry is supported.")

    return f"https://crates.io/api/v1/crates/{pkg["name"]}/{pkg["version"]}/download"


def download_tarball(pkg: dict, out_dir: str):

    url = get_download_url_for_tarball(pkg)
    filename = f"{pkg["name"]}-{pkg["version"]}.tar.gz"

    # TODO: allow legacy checksum specification, see importCargoLock for example
    #       also, don't forget about the other usage of the checksum
    expected_checksum = pkg["checksum"]

    tarball_out_dir = os.path.join(out_dir, "tarballs", filename)
    eprint(f"Fetching {url} -> tarballs/{filename}")

    download_file_with_checksum(url, tarball_out_dir, expected_checksum)


def download_git_tree(url: str, git_sha_rev: str, out_dir: str):

    tree_out_dir = os.path.join(out_dir, "git", git_sha_rev)
    eprint(f"Fetching {url}#{git_sha_rev} -> git/{git_sha_rev}")

    subprocess.check_output(["nix-prefetch-git", "--builder", "--quiet", "--url", url, "--rev", git_sha_rev, "--out", tree_out_dir])


GIT_SOURCE_REGEX = re.compile("git\\+(?P<url>[^?]+)(\\?(?P<type>rev|tag|branch)=(?P<value>.*))?#(?P<git_sha_rev>.*)")


def parse_git_source(source: str):
    matches = GIT_SOURCE_REGEX.match(source)
    if matches is None:
        raise Exception(f"Unable to process git source: {source}.")
    return matches.groupdict()


def create_vendor_staging(lockfile_path: str, out_dir: str):
    cargo_toml = load_toml(lockfile_path)

    git_packages: list[dict] = []
    registry_packages: list[dict] = []

    for pkg in cargo_toml["package"]:
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

    git_sha_rev_to_url = {}
    for pkg in git_packages:
        source_info = parse_git_source(pkg["source"])
        git_sha_rev_to_url[source_info["git_sha_rev"]] = source_info["url"]

    os.makedirs(out_dir, exist_ok=True)
    shutil.copy(lockfile_path, os.path.join(out_dir, "Cargo.lock"))

    pool = mp.Pool(min(10, mp.cpu_count()))

    if len(git_packages) != 0:
        os.mkdir(os.path.join(out_dir, "git"))
        # run download jobs in parallel
        pool.starmap(download_git_tree, ((url, git_sha_rev, out_dir) for git_sha_rev, url in git_sha_rev_to_url.items()))

    if len(registry_packages) != 0:
        os.mkdir(os.path.join(out_dir, "tarballs"))
        # run download jobs in parallel
        pool.starmap(download_tarball, ((pkg, out_dir) for pkg in registry_packages))

    pool.close()


def get_manifest_metadata(manifest_path: str):
    output = subprocess.check_output(["cargo", "metadata", "--format-version", "1", "--no-deps", "--manifest-path", manifest_path])
    return json.loads(output)


def try_get_crate_manifest_path_from_mainfest_path(manifest_path: str, crate_name: str) -> str | None:
    metadata = get_manifest_metadata(manifest_path)
    crate_manifest_path = next((pkg["manifest_path"] for pkg in metadata["packages"] if pkg["name"] == crate_name), None)
    return crate_manifest_path


def find_crate_manifest_in_tree(tree: str, crate_name: str):
    # in some cases Cargo.toml is not located at the top level, so we also look at subdirectories
    manifest_paths = (os.path.join(tree, path) for path in glob.iglob("**/Cargo.toml", root_dir=tree, recursive=True))

    for manifest_path in manifest_paths:
        res = try_get_crate_manifest_path_from_mainfest_path(manifest_path, crate_name)
        if res is not None:
            return res

    raise Exception(f"Couldn't find manifest for crate {crate_name} inside {tree}.")


def create_vendor(vendor_staging_dir: str, out_dir: str):
    lockfile_path = os.path.join(vendor_staging_dir, "Cargo.lock")
    os.makedirs(out_dir, exist_ok=True)
    shutil.copy(lockfile_path, os.path.join(out_dir, "Cargo.lock"))

    cargo_toml = load_toml(lockfile_path)

    config_lines = [
        '[source.crates-io]',
        'replace-with = "vendored-sources"',
        '[source.vendored-sources]',
        'directory = "@vendor@"',
    ]

    seen_source_keys = set()
    for pkg in cargo_toml["package"]:

        # ignore local dependenices
        if "source" not in pkg.keys():
            continue

        source: str = pkg["source"]

        if source.startswith("git+"):

            source_info = parse_git_source(pkg["source"])
            git_sha_rev = source_info["git_sha_rev"]

            git_tree = os.path.join(vendor_staging_dir, "git", git_sha_rev)
            crate_manifest_path = find_crate_manifest_in_tree(git_tree, pkg["name"])
            crate_tree = os.path.dirname(crate_manifest_path)

            dir_name = f"{pkg["name"]}-{pkg["version"]}"
            crate_out_dir = os.path.join(out_dir, dir_name)
            shutil.copytree(crate_tree, crate_out_dir)
            os.chmod(crate_out_dir, 0o755)

            with open(crate_manifest_path, "r") as f:
                manifest_data = f.read()

            if "workspace" in manifest_data:
                workspace_root = get_manifest_metadata(crate_manifest_path)["workspace_root"]
                os.chmod(os.path.join(crate_out_dir, "Cargo.toml"), 0o644)
                subprocess.check_output(["replace-workspace-values", os.path.join(crate_out_dir, "Cargo.toml"), os.path.join(workspace_root, "Cargo.toml")])

            with open(os.path.join(crate_out_dir, ".cargo-checksum.json"), "w") as f:
                f.write('{"files":{},"package":null}')

            eprint(crate_out_dir)

            source_key = source[:source.find("#")]

            if source_key not in seen_source_keys:
                config_lines.append(f'[source."{source_key}"]')
                config_lines.append(f'git = "{source_info["url"]}"')
                if source_info["type"] is not None:
                    config_lines.append(f'{source_info["type"]} = "{source_info["value"]}"')
                config_lines.append('replace-with = "vendored-sources"')

                seen_source_keys.add(source_key)

        elif source.startswith("registry+"):
            filename = f"{pkg["name"]}-{pkg["version"]}.tar.gz"
            dir_name = f"{pkg["name"]}-{pkg["version"]}"
            crate_out_dir = os.path.join(out_dir, dir_name)
            tarball_path = os.path.join(vendor_staging_dir, "tarballs", filename)

            os.mkdir(crate_out_dir)
            subprocess.check_output(["tar", "xf", tarball_path, "-C", crate_out_dir, "--strip-components=1"])

            with open(os.path.join(crate_out_dir, ".cargo-checksum.json"), "w") as f:
                f.write(f'{{"files":{{}},"package":"{pkg["checksum"]}"}}')

            eprint(crate_out_dir)

        else:
            raise Exception(f"Can't process source: {source}.")

    os.mkdir(os.path.join(out_dir, ".cargo"))
    with open(os.path.join(out_dir, ".cargo", "config.toml"), "w") as config_file:
        config_file.writelines(line + "\n" for line in config_lines)


def main() -> None:
    method = sys.argv[1]

    if method == "create-vendor-staging":
        create_vendor_staging(lockfile_path=sys.argv[2], out_dir=sys.argv[3])
    elif method == "create-vendor":
        create_vendor(vendor_staging_dir=sys.argv[2], out_dir=sys.argv[3])
    else:
        raise Exception(f"Unknown method: {method}")


if __name__ == "__main__":
    main()
