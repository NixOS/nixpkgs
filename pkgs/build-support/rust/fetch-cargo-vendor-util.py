import functools
import hashlib
import json
import multiprocessing as mp
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from os.path import islink, realpath
from pathlib import Path
from typing import Any, TypedDict, cast
from urllib.parse import unquote

import requests
from requests.adapters import HTTPAdapter, Retry

eprint = functools.partial(print, file=sys.stderr)


def load_toml(path: Path) -> dict[str, Any]:
    with open(path, "rb") as f:
        return tomllib.load(f)


def get_lockfile_version(cargo_lock_toml: dict[str, Any]) -> int:
    # lockfile v1 and v2 don't have the `version` key, so assume v2
    version = cargo_lock_toml.get("version", 2)

    # TODO: add logic for differentiating between v1 and v2

    return version


def create_http_session() -> requests.Session:
    retries = Retry(
        total=5,
        backoff_factor=0.5,
        status_forcelist=[500, 502, 503, 504]
    )
    session = requests.Session()
    session.mount('http://', HTTPAdapter(max_retries=retries))
    session.mount('https://', HTTPAdapter(max_retries=retries))
    return session


def download_file_with_checksum(session: requests.Session, url: str, destination_path: Path) -> str:
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


# get the .dl key from the config.json
# See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
def get_dl_for_registry(registry_uri: str, session: requests.Session) -> str:
    if registry_uri.startswith("sparse+"):
        root_url = registry_uri[7:].rstrip("/")
        with session.get(root_url + "/config.json") as response:
            registry_config: dict[str, str] = response.json()
    elif registry_uri.startswith("registry+"):
        # use spare-checkout to only get the config.json file from the registry's git repo
        url = registry_uri[9:]
        tmp_dir = Path(tempfile.mkdtemp())
        cmd = ["nix-prefetch-git", "--builder", "--quiet", "--url", url, "--rev", "HEAD", "--sparse-checkout", "config.json", "--out", str(tmp_dir)]
        subprocess.check_output(cmd)
        with open(tmp_dir / "config.json") as f:
            registry_config: dict[str, str] = json.load(f)
    else:
        raise Exception(f"Unknown registry format in URI: {registry_uri}")

    dl = registry_config["dl"]
    auth_required = registry_config.get("auth-required", False)
    if auth_required:
        eprint(f'Warning: Registry "{registry_uri}" requires authentication!')
    return dl


# See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-files
def name_to_prefix(name: str) -> str:
    nl = len(name)
    if nl <= 2:
        return str(nl)
    if nl == 3:
        return "3/" + name[0]
    return name[0:2] + "/" + name[2:4]


# See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
def get_download_url_for_tarball(pkg: dict[str, Any], dl: str) -> str:
    prefix = name_to_prefix(pkg["name"])
    url = dl if "{" in dl else dl + "/{crate}/{version}/download"
    url = url.replace("{crate}", pkg["name"])
    url = url.replace("{version}", pkg["version"])
    url = url.replace("{prefix}", prefix)
    url = url.replace("{lowerprefix}", prefix.lower())
    url = url.replace("{sha256-checksum}", pkg["checksum"])
    return url


def download_crate_tarball(session: requests.Session, url: str, out_path: Path, expected_checksum: str) -> None:
    out_path.parent.mkdir(exist_ok=True)

    eprint(f"Fetching {url} -> {out_path}")
    calculated_checksum = download_file_with_checksum(session, url, out_path)

    if calculated_checksum != expected_checksum:
        raise Exception(f"Hash mismatch! File fetched from {url} had checksum {calculated_checksum}, expected {expected_checksum}.")


def download_git_tree(url: str, git_sha_rev: str, out_dir: Path) -> None:

    tree_out_dir = out_dir / "git" / git_sha_rev
    eprint(f"Fetching {url}#{git_sha_rev} -> git/{git_sha_rev}")

    cmd = ["nix-prefetch-git", "--builder", "--quiet", "--fetch-submodules", "--url", url, "--rev", git_sha_rev, "--out", str(tree_out_dir)]
    subprocess.check_output(cmd)


GIT_SOURCE_REGEX = re.compile("git\\+(?P<url>[^?]+)(\\?(?P<type>rev|tag|branch)=(?P<value>.*))?#(?P<git_sha_rev>.*)")


class GitSourceInfo(TypedDict):
    url: str
    type: str | None
    value: str | None
    git_sha_rev: str


def parse_git_source(source: str, lockfile_version: int) -> GitSourceInfo:
    match = GIT_SOURCE_REGEX.match(source)
    if match is None:
        raise Exception(f"Unable to process git source: {source}.")

    source_info = cast(GitSourceInfo, match.groupdict(default=None))

    # the source URL is URL-encoded in lockfile_version >=4
    # since we just used regex to parse it we have to manually decode the escaped branch/tag name
    if lockfile_version >= 4 and source_info["value"] is not None:
        source_info["value"] = unquote(source_info["value"])

    return source_info


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
        elif source.startswith("registry+") or source.startswith("sparse+"):
            registry_packages.append(pkg)
        else:
            raise Exception(f"Can't process source: {source}.")

    git_sha_rev_to_url: dict[str, str] = {}
    for pkg in git_packages:
        source_info = parse_git_source(pkg["source"], lockfile_version)
        git_sha_rev_to_url[source_info["git_sha_rev"]] = source_info["url"]

    registry_source_to_dir_name = {}

    # the download directory name must be kept "tarballs" for crates-io registries for legacy reasons
    registry_source_to_dir_name["registry+https://github.com/rust-lang/crates.io-index"] = "tarballs"
    registry_source_to_dir_name["sparse+https://index.crates.io/"] = "tarballs"

    # all other registies are numbered starting from 1
    next_registry_ind = 1
    for pkg in registry_packages:
        source = pkg["source"]
        if source not in registry_source_to_dir_name:
            registry_source_to_dir_name[source] = f"registry-{next_registry_ind}"
            next_registry_ind += 1

    registry_source_to_dl = {}
    session_0 = create_http_session()
    for pkg in registry_packages:
        source = pkg["source"]
        if source not in registry_source_to_dl:
            registry_source_to_dl[source] = get_dl_for_registry(source, session_0)

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
            session = create_http_session()

            def make_registry_crate_download_args(pkg: dict[str, Any]):
                nonlocal session, registry_source_to_dl, registry_source_to_dir_name
                source = pkg["source"]
                dl = registry_source_to_dl[source]
                url = get_download_url_for_tarball(pkg, dl)
                dir_name = registry_source_to_dir_name[source]

                # Note: lockfile v1 doesn't have its checksum in the pkg dictionary itself, so it's not supported
                checksum = pkg["checksum"]
                filename = f'{pkg["name"]}-{pkg["version"]}.tar.gz'
                out_path = out_dir / dir_name / filename
                return (session, url, out_path, checksum)

            tarball_args_gen = (make_registry_crate_download_args(pkg) for pkg in registry_packages)
            pool.starmap(download_crate_tarball, tarball_args_gen)


def get_manifest_metadata(manifest_path: Path) -> dict[str, Any]:
    cmd = ["cargo", "metadata", "--format-version", "1", "--no-deps", "--manifest-path", str(manifest_path)]
    output = subprocess.check_output(cmd)
    return json.loads(output)


def try_get_crate_manifest_path_from_mainfest_path(manifest_path: Path, crate_name: str) -> Path | None:
    metadata = get_manifest_metadata(manifest_path)

    for pkg in metadata["packages"]:
        if pkg["name"] == crate_name:
            return Path(pkg["manifest_path"])

    return None


def find_crate_manifest_in_tree(tree: Path, crate_name: str) -> Path:
    # in some cases Cargo.toml is not located at the top level, so we also look at subdirectories
    manifest_paths = tree.glob("**/Cargo.toml")

    for manifest_path in manifest_paths:
        res = try_get_crate_manifest_path_from_mainfest_path(manifest_path, crate_name)
        if res is not None:
            return res

    raise Exception(f"Couldn't find manifest for crate {crate_name} inside {tree}.")


def copy_and_patch_git_crate_subtree(git_tree: Path, crate_name: str, crate_out_dir: Path) -> None:

    # This function will get called by copytree to decide which entries of a directory should be copied
    # We'll copy everything except symlinks that are invalid
    def ignore_func(dir_str: str, path_strs: list[str]) -> list[str]:
        ignorelist: list[str] = []

        dir = Path(realpath(dir_str, strict=True))

        for path_str in path_strs:
            path = dir / path_str
            if not islink(path):
                continue

            # Filter out cyclic symlinks and symlinks pointing at nonexistant files
            try:
                target_path = Path(realpath(path, strict=True))
            except OSError:
                ignorelist.append(path_str)
                eprint(f"Failed to resolve symlink, ignoring: {path}")
                continue

            # Filter out symlinks that point outside of the current crate's base git tree
            # This can be useful if the nix build sandbox is turned off and there is a symlink to a common absolute path
            if not target_path.is_relative_to(git_tree):
                ignorelist.append(path_str)
                eprint(f"Symlink points outside of the crate's base git tree, ignoring: {path} -> {target_path}")
                continue

        return ignorelist

    crate_manifest_path = find_crate_manifest_in_tree(git_tree, crate_name)
    crate_tree = crate_manifest_path.parent

    eprint(f"Copying to {crate_out_dir}")
    shutil.copytree(crate_tree, crate_out_dir, ignore=ignore_func)
    crate_out_dir.chmod(0o755)

    with open(crate_manifest_path, "r") as f:
        manifest_data = f.read()

    if "workspace" in manifest_data:
        crate_manifest_metadata = get_manifest_metadata(crate_manifest_path)
        workspace_root = Path(crate_manifest_metadata["workspace_root"])

        root_manifest_path = workspace_root / "Cargo.toml"
        manifest_path = crate_out_dir / "Cargo.toml"

        manifest_path.chmod(0o644)
        eprint(f"Patching {manifest_path}")

        cmd = ["replace-workspace-values", str(manifest_path), str(root_manifest_path)]
        subprocess.check_output(cmd)


def extract_crate_tarball_contents(tarball_path: Path, crate_out_dir: Path) -> None:
    eprint(f"Unpacking to {crate_out_dir}")
    crate_out_dir.mkdir()
    cmd = ["tar", "xf", str(tarball_path), "-C", str(crate_out_dir), "--strip-components=1"]
    subprocess.check_output(cmd)


def create_vendor(vendor_staging_dir: Path, out_dir: Path) -> None:
    lockfile_path = vendor_staging_dir / "Cargo.lock"
    out_dir.mkdir(exist_ok=True)
    shutil.copy(lockfile_path, out_dir / "Cargo.lock")

    cargo_lock_toml = load_toml(lockfile_path)
    lockfile_version = get_lockfile_version(cargo_lock_toml)

    config_lines = [
        '[source.vendored-sources]',
        'directory = "@vendor@"',
        '[source.crates-io]',
        'replace-with = "vendored-sources"',
    ]

    seen_source_keys = set()
    for pkg in cargo_lock_toml["package"]:

        # ignore local dependenices
        if "source" not in pkg.keys():
            continue

        source: str = pkg["source"]

        dir_name = f"{pkg["name"]}-{pkg["version"]}"
        crate_out_dir = out_dir / dir_name

        if source.startswith("git+"):

            source_info = parse_git_source(pkg["source"], lockfile_version)

            git_sha_rev = source_info["git_sha_rev"]
            git_tree = vendor_staging_dir / "git" / git_sha_rev

            copy_and_patch_git_crate_subtree(git_tree, pkg["name"], crate_out_dir)

            # git based crates allow having no checksum information
            with open(crate_out_dir / ".cargo-checksum.json", "w") as f:
                json.dump({"files": {}}, f)

            source_key = source[0:source.find("#")]

            if source_key in seen_source_keys:
                continue

            seen_source_keys.add(source_key)

            config_lines.append(f'[source."{source_key}"]')
            config_lines.append(f'git = "{source_info["url"]}"')
            if source_info["type"] is not None:
                config_lines.append(f'{source_info["type"]} = "{source_info["value"]}"')
            config_lines.append('replace-with = "vendored-sources"')

        elif source.startswith("registry+"):

            filename = f"{pkg["name"]}-{pkg["version"]}.tar.gz"
            tarball_path = vendor_staging_dir / "tarballs" / filename

            extract_crate_tarball_contents(tarball_path, crate_out_dir)

            # non-git based crates need the package checksum at minimum
            with open(crate_out_dir / ".cargo-checksum.json", "w") as f:
                json.dump({"files": {}, "package": pkg["checksum"]}, f)

        else:
            raise Exception(f"Can't process source: {source}.")

    (out_dir / ".cargo").mkdir()
    with open(out_dir / ".cargo" / "config.toml", "w") as config_file:
        config_file.writelines(line + "\n" for line in config_lines)


def main() -> None:
    subcommand = sys.argv[1]

    subcommand_func_dict = {
        "create-vendor-staging": lambda: create_vendor_staging(lockfile_path=Path(sys.argv[2]), out_dir=Path(sys.argv[3])),
        "create-vendor": lambda: create_vendor(vendor_staging_dir=Path(sys.argv[2]), out_dir=Path(sys.argv[3]))
    }

    subcommand_func = subcommand_func_dict.get(subcommand)

    if subcommand_func is None:
        raise Exception(f"Unknown subcommand: '{subcommand}'. Must be one of {list(subcommand_func_dict.keys())}")

    subcommand_func()


if __name__ == "__main__":
    main()
