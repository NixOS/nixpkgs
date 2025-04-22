import functools
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from concurrent.futures import FIRST_EXCEPTION, Future, ThreadPoolExecutor, wait
from dataclasses import dataclass, field
from os.path import islink, realpath
from pathlib import Path
from typing import Any, cast
from urllib.parse import unquote

import requests
import tomli_w
from requests.adapters import HTTPAdapter, Retry

# Constants for controlling how the crates are downloaded from the registries via `requests`
# These do not affect the fetching of git dependencies
MAX_WORKERS = min(5, os.cpu_count() or 1)  # number of workers in the ThreadPoolExecutor
CONNECT_TIMEOUT = 2  # max seconds for establishing initial connection
READ_TIMEOUT = 10  # max seconds between receiving data packets
RETRY_COUNT = 3  # number of retries for fetching an url
BACKOFF_FACTOR = 0.5  # seconds to wait between retries (gets multiplied by 2 after every retry)

eprint = functools.partial(print, file=sys.stderr)


@dataclass
class RegistrySource:
    raw: str
    url: str
    is_sparse: bool
    ind: int = field(init=False)


@dataclass
class RegistryPackage:
    name: str
    version: str
    source: RegistrySource
    checksum: str


GIT_SOURCE_REGEX = re.compile(r"git\+(?P<url>[^?]+)(\?(?P<type>rev|tag|branch)=(?P<value>.*))?#(?P<git_sha_rev>.*)")


@dataclass
class GitSource:
    raw: str
    url: str
    type: str | None
    value: str | None
    git_sha_rev: str
    ind: int = field(init=False)


@dataclass
class GitPackage:
    name: str
    version: str
    source: GitSource


Source = RegistrySource | GitSource
Package = RegistryPackage | GitPackage


@dataclass
class Lockfile:
    version: int
    sources: list[Source]
    packages: list[Package]


def parse_git_source(raw_source: str, lockfile_version: int) -> GitSource:
    match = GIT_SOURCE_REGEX.match(raw_source)
    if match is None:
        raise Exception(f"Unable to process git source: {raw_source}.")

    parsed_dict = match.groupdict(default=None)
    url = cast(str, parsed_dict["url"])
    git_sha_rev = cast(str, parsed_dict["git_sha_rev"])

    source = GitSource(raw_source, url, parsed_dict["type"], parsed_dict["value"], git_sha_rev)

    # the source URL is URL-encoded in lockfile_version >=4
    # since we just used regex to parse it we have to manually decode the escaped branch/tag name
    if lockfile_version >= 4 and source.value is not None:
        source.value = unquote(source.value)

    return source


def parse_source(raw_source: str, lockfile_version: int) -> Source:
    if raw_source.startswith("git+"):
        return parse_git_source(raw_source, lockfile_version)
    elif raw_source.startswith("registry+"):
        return RegistrySource(raw=raw_source, url=raw_source[9:], is_sparse=False)
    elif raw_source.startswith("sparse+"):
        return RegistrySource(raw=raw_source, url=raw_source[7:].rstrip("/"), is_sparse=True)
    raise Exception(f"Cannot process source: {raw_source}.")


def load_lockfile(path: Path) -> Lockfile:
    with path.open("rb") as f:
        cargo_lock_toml = tomllib.load(f)

    # lockfile v1 and v2 don't have the `version` key, so assume v2 for now
    lockfile_version = cargo_lock_toml.get("version", 2)

    raw_packages: list[dict[str, str]] = cargo_lock_toml["package"]

    sources: list[Source] = []
    raw_source_to_source: dict[str, Source] = {}

    # we'll mark every source with an index in order of appearance
    # both git and registry sources have a different incrementing index
    # we reserve registry index 0 for both of the default crates-io registries

    for raw_source in ["registry+https://github.com/rust-lang/crates.io-index", "sparse+https://index.crates.io/"]:
        source = parse_source(raw_source, lockfile_version)
        source.ind = 0
        sources.append(source)
        raw_source_to_source[source.raw] = source

    next_registry_ind = 1
    next_git_ind = 0

    for raw_pkg in raw_packages:
        raw_source = raw_pkg.get("source", None)
        if raw_source is None:  # Skip local dependencies
            continue
        if raw_source in raw_source_to_source:
            continue

        source = parse_source(raw_source, lockfile_version)
        match source:
            case RegistrySource():
                source.ind = next_registry_ind
                next_registry_ind += 1
            case GitSource():
                source.ind = next_git_ind
                next_git_ind += 1

        sources.append(source)
        raw_source_to_source[source.raw] = source

    packages: list[Package] = []

    for raw_pkg in raw_packages:
        name = raw_pkg["name"]
        version = raw_pkg["version"]
        raw_source = raw_pkg.get("source", None)
        if raw_source is None:  # Skip local dependencies
            continue
        source = raw_source_to_source[raw_source]

        match source:
            case RegistrySource():
                checksum = raw_pkg.get("checksum", None)

                # lockfile v1 has the checksum values in a separate metadata table
                if checksum is None:
                    lockfile_version = 1
                    checksum_key = f"checksum {name} {version} ({source})"
                    checksum = cargo_lock_toml["metadata"][checksum_key]

                pkg = RegistryPackage(name, version, source, checksum)
            case GitSource():
                pkg = GitPackage(name, version, source)

        packages.append(pkg)

    return Lockfile(lockfile_version, sources, packages)


def create_http_session() -> requests.Session:
    retries = Retry(
        total=RETRY_COUNT,
        backoff_factor=BACKOFF_FACTOR,
        status_forcelist=[500, 502, 503, 504]
    )
    session = requests.Session()
    session.mount('http://', HTTPAdapter(max_retries=retries))
    session.mount('https://', HTTPAdapter(max_retries=retries))
    return session


def download_file_with_checksum(session: requests.Session, url: str, destination_path: Path) -> str:
    sha256_hash = hashlib.sha256()
    with session.get(url, stream=True, timeout=(CONNECT_TIMEOUT, READ_TIMEOUT)) as response:
        if not response.ok:
            raise Exception(f"Failed to fetch file from {url}. Status code: {response.status_code}")
        with destination_path.open("wb") as file:
            for chunk in response.iter_content(1024):  # Download in chunks
                if chunk:  # Filter out keep-alive chunks
                    file.write(chunk)
                    sha256_hash.update(chunk)

    # Compute the final checksum
    checksum = sha256_hash.hexdigest()
    return checksum


# Fetch the config.json file and get the .dl key from it
# See: https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration
def fetch_dl_for_registry_source(source: RegistrySource, session: requests.Session) -> str:
    if source.is_sparse:
        with session.get(source.url + "/config.json", timeout=(CONNECT_TIMEOUT, READ_TIMEOUT)) as response:
            registry_config: dict[str, str] = response.json()
    else:
        # use spare-checkout to only get the config.json file from the registry's git repo
        tmp_dir = Path(tempfile.mkdtemp())
        cmd = ["nix-prefetch-git", "--builder", "--quiet", "--url", source.url, "--rev", "HEAD", "--sparse-checkout", "config.json", "--out", str(tmp_dir)]
        subprocess.check_output(cmd)
        with (tmp_dir / "config.json").open("rb") as f:
            registry_config: dict[str, str] = json.load(f)

    dl = registry_config["dl"]
    auth_required = registry_config.get("auth-required", False)
    if auth_required:
        eprint(f'Warning: Registry "{source.url}" requires authentication!')
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
def make_download_url_for_tarball(pkg: RegistryPackage, dl: str) -> str:
    prefix = name_to_prefix(pkg.name)
    url = dl if "{" in dl else dl + "/{crate}/{version}/download"
    url = url.replace("{crate}", pkg.name)
    url = url.replace("{version}", pkg.version)
    url = url.replace("{prefix}", prefix)
    url = url.replace("{lowerprefix}", prefix.lower())
    url = url.replace("{sha256-checksum}", pkg.checksum)
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


def create_vendor_staging(lockfile_path: Path, out_dir: Path) -> None:
    lockfile = load_lockfile(lockfile_path)

    git_sources = [source for source in lockfile.sources if isinstance(source, GitSource)]
    registry_sources = [source for source in lockfile.sources if isinstance(source, RegistrySource)]
    registry_packages = [pkg for pkg in lockfile.packages if isinstance(pkg, RegistryPackage)]

    session = create_http_session()

    raw_registry_source_to_dl: dict[str, str] = {}
    for source in registry_sources:
        raw_registry_source_to_dl[source.raw] = fetch_dl_for_registry_source(source, session)

    out_dir.mkdir(exist_ok=True)
    shutil.copy(lockfile_path, out_dir / "Cargo.lock")

    # fetch git trees sequentially, since fetching concurrently leads to flaky behaviour
    if len(git_sources) != 0:
        (out_dir / "git").mkdir()
        for source in git_sources:
            download_git_tree(source.url, source.git_sha_rev, out_dir)

    if len(registry_packages) != 0:
        (out_dir / "tarballs").mkdir()

        eprint(f"Downloading tarballs with {MAX_WORKERS} workers...")
        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
            futures: list[Future[None]] = []

            for pkg in registry_packages:
                source = pkg.source

                # the download directory name must be kept "tarballs" for crates-io registries for legacy reasons
                dir_name = "tarballs" if source.ind == 0 else f"registry-{source.ind}"
                dl = raw_registry_source_to_dl[source.raw]
                url = make_download_url_for_tarball(pkg, dl)

                checksum = pkg.checksum
                filename = f'{pkg.name}-{pkg.version}.tar.gz'
                out_path = out_dir / dir_name / filename

                future = executor.submit(download_crate_tarball, session, url, out_path, checksum)
                futures.append(future)

            # fail early if a worker raises an exception
            done, _ = wait(futures, return_when=FIRST_EXCEPTION)
            for f in done:
                e = f.exception()
                if e is None:
                    continue
                executor.shutdown(cancel_futures=True)
                raise Exception(f"Failed to download tarball: {e}")


def get_manifest_metadata(manifest_path: Path) -> dict[str, Any]:
    cmd = ["cargo", "metadata", "--format-version", "1", "--no-deps", "--manifest-path", str(manifest_path)]
    output = subprocess.check_output(cmd)
    return json.loads(output)


def try_get_crate_manifest_path_from_manifest_path(manifest_path: Path, crate_name: str) -> Path | None:
    try:
        metadata = get_manifest_metadata(manifest_path)
    except subprocess.CalledProcessError:
        eprint(f"Warning: cargo metadata failed for {manifest_path}, skipping")
        return None

    for pkg in metadata["packages"]:
        if pkg["name"] == crate_name:
            return Path(pkg["manifest_path"])

    return None


def find_crate_manifest_in_tree(tree: Path, crate_name: str) -> Path:
    # Scan all Cargo.toml files; sort by depth/path to make ordering deterministic
    # and prefer less-nested manifests first.
    manifest_paths = sorted(
        tree.glob("**/Cargo.toml"),
        key=lambda path: (len(path.parts), str(path)),
    )

    for manifest_path in manifest_paths:
        res = try_get_crate_manifest_path_from_manifest_path(manifest_path, crate_name)
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

    manifest_data = crate_manifest_path.read_text()

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


def make_git_source_selector(source: GitSource) -> dict[str, str]:
    selector = {}
    selector["git"] = source.url
    if source.type is not None:
        selector[source.type] = source.value
    return selector


def make_registry_source_selector(source: RegistrySource) -> dict[str, str]:
    registry = source.raw if source.is_sparse else source.url
    selector = {}
    selector["registry"] = registry
    return selector


def create_vendor(vendor_staging_dir: Path, out_dir: Path) -> None:
    lockfile_path = vendor_staging_dir / "Cargo.lock"
    out_dir.mkdir(exist_ok=True)
    shutil.copy(lockfile_path, out_dir / "Cargo.lock")

    lockfile = load_lockfile(lockfile_path)

    source_config = {}

    def add_source_replacement(
        orig_key: str,
        orig_selector: dict[str, str],
        vendored_key: str,
        vendored_dir: str
    ) -> None:
        source_config[vendored_key] = {}
        source_config[vendored_key]["directory"] = vendored_dir
        source_config[orig_key] = orig_selector
        source_config[orig_key]["replace-with"] = vendored_key

    add_source_replacement(
        orig_key="crates-io",
        orig_selector={},  # there is an internal selector defined for the `crates-io` source
        vendored_key="vendored-source-registry-0",
        vendored_dir="@vendor@/source-registry-0"
    )

    for source in lockfile.sources:
        match source:
            case RegistrySource():
                if source.ind == 0:  # crates-io was already handled separately
                    continue
                add_source_replacement(
                    orig_key=f"original-source-registry-{source.ind}",
                    orig_selector=make_registry_source_selector(source),
                    vendored_key=f"vendored-source-registry-{source.ind}",
                    vendored_dir=f"@vendor@/source-registry-{source.ind}"
                )
            case GitSource():
                add_source_replacement(
                    orig_key=f"original-source-git-{source.ind}",
                    orig_selector=make_git_source_selector(source),
                    vendored_key=f"vendored-source-git-{source.ind}",
                    vendored_dir=f"@vendor@/source-git-{source.ind}"
                )

    config_path = out_dir / ".cargo" / "config.toml"
    config_path.parent.mkdir()

    with config_path.open("wb") as config_file:
        tomli_w.dump({"source": source_config}, config_file)

    for pkg in lockfile.packages:
        match pkg:
            case GitPackage():
                crate_out_dir = out_dir / f"source-git-{pkg.source.ind}" / f"{pkg.name}-{pkg.version}"
                crate_out_dir.parent.mkdir(exist_ok=True)

                git_sha_rev = pkg.source.git_sha_rev
                git_tree = vendor_staging_dir / "git" / git_sha_rev

                copy_and_patch_git_crate_subtree(git_tree, pkg.name, crate_out_dir)

                # git based crates allow having no checksum information
                with (crate_out_dir / ".cargo-checksum.json").open("w") as f:
                    json.dump({"files": {}}, f)

            case RegistryPackage():
                crate_out_dir = out_dir / f"source-registry-{pkg.source.ind}" / f"{pkg.name}-{pkg.version}"
                crate_out_dir.parent.mkdir(exist_ok=True)

                filename = f"{pkg.name}-{pkg.version}.tar.gz"

                # the download directory name must be kept "tarballs" for crates-io registries for legacy reasons
                dir_name = "tarballs" if pkg.source.ind == 0 else f"registry-{pkg.source.ind}"

                tarball_path = vendor_staging_dir / dir_name / filename

                extract_crate_tarball_contents(tarball_path, crate_out_dir)

                # non-git based crates need the package checksum at minimum
                with (crate_out_dir / ".cargo-checksum.json").open("w") as f:
                    json.dump({"files": {}, "package": pkg.checksum}, f)


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
