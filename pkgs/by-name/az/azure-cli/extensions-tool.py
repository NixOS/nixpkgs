#!/usr/bin/env python

import argparse
import base64
import datetime
import json
import logging
import os
import sys
from dataclasses import asdict, dataclass, replace
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple
from urllib.request import Request, urlopen

import git
from packaging.version import Version, parse

INDEX_URL = "https://azcliextensionsync.blob.core.windows.net/index1/index.json"

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Ext:
    pname: str
    version: Version
    url: str
    hash: str
    description: str


def _read_cached_index(path: Path) -> Tuple[datetime.datetime, Any]:
    with open(path, "r") as f:
        data = f.read()

    j = json.loads(data)
    cache_date_str = j["cache_date"]
    if cache_date_str:
        cache_date = datetime.datetime.fromisoformat(cache_date_str)
    else:
        cache_date = datetime.datetime.min
    return cache_date, data


def _write_index_to_cache(data: Any, path: Path):
    j = json.loads(data)
    j["cache_date"] = datetime.datetime.now().isoformat()
    with open(path, "w") as f:
        json.dump(j, f, indent=2)


def _fetch_remote_index():
    r = Request(INDEX_URL)
    with urlopen(r) as resp:
        return resp.read()


def get_extension_index(cache_dir: Path) -> Set[Ext]:
    index_file = cache_dir / "index.json"
    os.makedirs(cache_dir, exist_ok=True)

    try:
        index_cache_date, index_data = _read_cached_index(index_file)
    except FileNotFoundError:
        logger.info("index has not been cached, downloading from source")
        logger.info("creating index cache in %s", index_file)
        _write_index_to_cache(_fetch_remote_index(), index_file)
        return get_extension_index(cache_dir)

    if (
        index_cache_date
        and datetime.datetime.now() - index_cache_date > datetime.timedelta(days=1)
    ):
        logger.info(
            "cache is outdated (%s), refreshing",
            datetime.datetime.now() - index_cache_date,
        )
        _write_index_to_cache(_fetch_remote_index(), index_file)
        return get_extension_index(cache_dir)

    logger.info("using index cache from %s", index_file)
    return json.loads(index_data)


def _read_extension_set(extensions_generated: Path) -> Set[Ext]:
    with open(extensions_generated, "r") as f:
        data = f.read()

    parsed_exts = {Ext(**json_ext) for _pname, json_ext in json.loads(data).items()}
    parsed_exts_with_ver = set()
    for ext in parsed_exts:
        ext2 = replace(ext, version=parse(ext.version))
        parsed_exts_with_ver.add(ext2)

    return parsed_exts_with_ver


def _write_extension_set(extensions_generated: Path, extensions: Set[Ext]) -> None:
    set_without_ver = {replace(ext, version=str(ext.version)) for ext in extensions}
    ls = list(set_without_ver)
    ls.sort(key=lambda e: e.pname)
    with open(extensions_generated, "w") as f:
        json.dump({ext.pname: asdict(ext) for ext in ls}, f, indent=2)
        f.write("\n")


def _convert_hash_digest_from_hex_to_b64_sri(s: str) -> str:
    try:
        b = bytes.fromhex(s)
    except ValueError as err:
        logger.error("not a hex value: %s", str(err))
        raise err

    return f"sha256-{base64.b64encode(b).decode('utf-8')}"


def _commit(repo: git.Repo, message: str, files: List[Path], actor: git.Actor) -> None:
    repo.index.add([str(f.resolve()) for f in files])
    if repo.index.diff("HEAD"):
        logger.info(f'committing to nixpkgs "{message}"')
        repo.index.commit(message, author=actor, committer=actor)
    else:
        logger.warning("no changes in working tree to commit")


def _filter_invalid(o: Dict[str, Any]) -> bool:
    if "metadata" not in o:
        logger.warning("extension without metadata")
        return False
    metadata = o["metadata"]
    if "name" not in metadata:
        logger.warning("extension without name")
        return False
    if "version" not in metadata:
        logger.warning(f"{metadata['name']} without version")
        return False
    if "azext.minCliCoreVersion" not in metadata:
        logger.warning(
            f"{metadata['name']} {metadata['version']} does not have azext.minCliCoreVersion"
        )
        return False
    if "summary" not in metadata:
        logger.info(f"{metadata['name']} {metadata['version']} without summary")
        return False
    if "downloadUrl" not in o:
        logger.warning(f"{metadata['name']} {metadata['version']} without downloadUrl")
        return False
    if "sha256Digest" not in o:
        logger.warning(f"{metadata['name']} {metadata['version']} without sha256Digest")
        return False

    return True


def _filter_compatible(o: Dict[str, Any], cli_version: Version) -> bool:
    minCliVersion = parse(o["metadata"]["azext.minCliCoreVersion"])
    return cli_version >= minCliVersion


def _transform_dict_to_obj(o: Dict[str, Any]) -> Ext:
    m = o["metadata"]
    return Ext(
        pname=m["name"],
        version=parse(m["version"]),
        url=o["downloadUrl"],
        hash=_convert_hash_digest_from_hex_to_b64_sri(o["sha256Digest"]),
        description=m["summary"].rstrip("."),
    )


def _get_latest_version(versions: dict) -> dict:
    return max(versions, key=lambda e: parse(e["metadata"]["version"]), default=None)


def processExtension(
    extVersions: dict,
    cli_version: Version,
    ext_name: Optional[str] = None,
    requirements: bool = False,
) -> Optional[Ext]:
    versions = filter(_filter_invalid, extVersions)
    versions = filter(lambda v: _filter_compatible(v, cli_version), versions)
    latest = _get_latest_version(versions)
    if not latest:
        return None
    if ext_name and latest["metadata"]["name"] != ext_name:
        return None
    if not requirements and "run_requires" in latest["metadata"]:
        return None

    return _transform_dict_to_obj(latest)


def _diff_sets(
    set_local: Set[Ext], set_remote: Set[Ext]
) -> Tuple[Set[Ext], Set[Ext], Set[Tuple[Ext, Ext]]]:
    local_exts = {ext.pname: ext for ext in set_local}
    remote_exts = {ext.pname: ext for ext in set_remote}
    only_local = local_exts.keys() - remote_exts.keys()
    only_remote = remote_exts.keys() - local_exts.keys()
    both = remote_exts.keys() & local_exts.keys()
    return (
        {local_exts[pname] for pname in only_local},
        {remote_exts[pname] for pname in only_remote},
        {(local_exts[pname], remote_exts[pname]) for pname in both},
    )


def _filter_updated(e: Tuple[Ext, Ext]) -> bool:
    prev, new = e
    return prev != new


def main() -> None:
    sh = logging.StreamHandler(sys.stderr)
    sh.setFormatter(
        logging.Formatter(
            "[%(asctime)s] [%(levelname)8s] --- %(message)s (%(filename)s:%(lineno)s)",
            "%Y-%m-%d %H:%M:%S",
        )
    )
    logging.basicConfig(level=logging.INFO, handlers=[sh])

    parser = argparse.ArgumentParser(
        prog="azure-cli.extensions-tool",
        description="Script to handle Azure CLI extension updates",
    )
    parser.add_argument(
        "--cli-version", type=str, help="version of azure-cli (required)"
    )
    parser.add_argument("--extension", type=str, help="name of extension to query")
    parser.add_argument(
        "--cache-dir",
        type=Path,
        help="path where to cache the extension index",
        default=Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache"))
        / "azure-cli-extensions-tool",
    )
    parser.add_argument(
        "--requirements",
        action=argparse.BooleanOptionalAction,
        help="whether to list extensions that have requirements",
    )
    parser.add_argument(
        "--commit",
        action=argparse.BooleanOptionalAction,
        help="whether to commit changes to git",
    )
    args = parser.parse_args()

    repo = git.Repo(Path(".").resolve(), search_parent_directories=True)
    # Workaround for https://github.com/gitpython-developers/GitPython/issues/1923
    author = repo.config_reader().get_value("user", "name").lstrip('"').rstrip('"')
    email = repo.config_reader().get_value("user", "email").lstrip('"').rstrip('"')
    actor = git.Actor(author, email)

    index = get_extension_index(args.cache_dir)
    assert index["formatVersion"] == "1"  # only support formatVersion 1
    extensions_remote = index["extensions"]

    cli_version = parse(args.cli_version)

    extensions_remote_filtered = set()
    for _ext_name, extension in extensions_remote.items():
        extension = processExtension(extension, cli_version, args.extension)
        if extension:
            extensions_remote_filtered.add(extension)

    extension_file = (
        Path(repo.working_dir) / "pkgs/by-name/az/azure-cli/extensions-generated.json"
    )
    extensions_local = _read_extension_set(extension_file)
    extensions_local_filtered = set()
    if args.extension:
        extensions_local_filtered = filter(
            lambda ext: args.extension == ext.pname, extensions_local
        )
    else:
        extensions_local_filtered = extensions_local

    removed, init, updated = _diff_sets(
        extensions_local_filtered, extensions_remote_filtered
    )
    updated = set(filter(_filter_updated, updated))

    logger.info("initialized extensions:")
    for ext in init:
        logger.info(f"  {ext.pname} {ext.version}")
    logger.info("removed extensions:")
    for ext in removed:
        logger.info(f"  {ext.pname} {ext.version}")
    logger.info("updated extensions:")
    for prev, new in updated:
        logger.info(f"  {prev.pname} {prev.version} -> {new.version}")

    for ext in init:
        extensions_local.add(ext)
        commit_msg = f"azure-cli-extensions.{ext.pname}: init at {ext.version}"
        _write_extension_set(extension_file, extensions_local)
        if args.commit:
            _commit(repo, commit_msg, [extension_file], actor)

    for prev, new in updated:
        extensions_local.remove(prev)
        extensions_local.add(new)
        commit_msg = (
            f"azure-cli-extensions.{prev.pname}: {prev.version} -> {new.version}"
        )
        _write_extension_set(extension_file, extensions_local)
        if args.commit:
            _commit(repo, commit_msg, [extension_file], actor)

    for ext in removed:
        extensions_local.remove(ext)
        # TODO: Add additional check why this is removed
        # TODO: Add an alias to extensions manual?
        commit_msg = f"azure-cli-extensions.{ext.pname}: remove"
        _write_extension_set(extension_file, extensions_local)
        if args.commit:
            _commit(repo, commit_msg, [extension_file], actor)


if __name__ == "__main__":
    main()
