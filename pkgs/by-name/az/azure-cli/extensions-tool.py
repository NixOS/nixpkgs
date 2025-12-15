#!/usr/bin/env python

import argparse
import base64
import datetime
import json
import logging
import os
import subprocess
import sys
from collections.abc import Callable
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


def _write_index_to_cache(data: Any, path: Path) -> None:
    j = json.loads(data)
    j["cache_date"] = datetime.datetime.now().isoformat()
    with open(path, "w") as f:
        json.dump(j, f, indent=2)


def _fetch_remote_index() -> Any:
    r = Request(INDEX_URL)
    with urlopen(r) as resp:
        return resp.read()


def get_extension_index(cache_dir: Path) -> Any:
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
    return bool(cli_version >= minCliVersion)


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


def find_extension_version(
    extVersions: dict,
    cli_version: Version,
    ext_name: Optional[str] = None,
    requirements: bool = False,
) -> Optional[Dict[str, Any]]:
    versions = filter(_filter_invalid, extVersions)
    versions = filter(lambda v: _filter_compatible(v, cli_version), versions)
    latest = _get_latest_version(versions)
    if not latest:
        return None
    if ext_name and latest["metadata"]["name"] != ext_name:
        return None
    if not requirements and "run_requires" in latest["metadata"]:
        return None
    return latest


def find_and_transform_extension_version(
    extVersions: dict,
    cli_version: Version,
    ext_name: Optional[str] = None,
    requirements: bool = False,
) -> Optional[Ext]:
    latest = find_extension_version(extVersions, cli_version, ext_name, requirements)
    if not latest:
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


@dataclass(frozen=True)
class AttrPos:
    file: str
    line: int
    column: int


def nix_get_value(attr_path: str) -> Optional[str]:
    try:
        output = (
            subprocess.run(
                [
                    "nix-instantiate",
                    "--eval",
                    "--strict",
                    "--json",
                    "-E",
                    f"with import ./. {{ }}; {attr_path}",
                ],
                stdout=subprocess.PIPE,
                text=True,
                check=True,
            )
            .stdout.rstrip()
            .strip('"')
        )
    except subprocess.CalledProcessError as e:
        logger.error("failed to nix-instantiate: %s", e)
        return None
    return output


def nix_unsafe_get_attr_pos(attr: str, attr_path: str) -> Optional[AttrPos]:
    try:
        output = subprocess.run(
            [
                "nix-instantiate",
                "--eval",
                "--strict",
                "--json",
                "-E",
                f'with import ./. {{ }}; (builtins.unsafeGetAttrPos "{attr}" {attr_path})',
            ],
            stdout=subprocess.PIPE,
            text=True,
            check=True,
        ).stdout.rstrip()
    except subprocess.CalledProcessError as e:
        logger.error("failed to unsafeGetAttrPos: %s", e)
        return None
    if output == "null":
        logger.error("failed to unsafeGetAttrPos: nix-instantiate returned 'null'")
        return None
    pos = json.loads(output)
    return AttrPos(pos["file"], pos["line"] - 1, pos["column"])


def edit_file(file: str, rewrite: Callable[[str], str]) -> None:
    with open(file, "r") as f:
        lines = f.readlines()
    lines = [rewrite(line) for line in lines]
    with open(file, "w") as f:
        f.writelines(lines)


def edit_file_at_pos(pos: AttrPos, rewrite: Callable[[str], str]) -> None:
    with open(pos.file, "r") as f:
        lines = f.readlines()
    lines[pos.line] = rewrite(lines[pos.line])
    with open(pos.file, "w") as f:
        f.writelines(lines)


def read_value_at_pos(pos: AttrPos) -> str:
    with open(pos.file, "r") as f:
        lines = f.readlines()
        return value_from_nix_line(lines[pos.line])


def value_from_nix_line(line: str) -> str:
    return line.split("=")[1].strip().strip(";").strip('"')


def replace_value_in_nix_line(new: str) -> Callable[[str], str]:
    return lambda line: line.replace(value_from_nix_line(line), new)


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
    parser.add_argument(
        "--init",
        action=argparse.BooleanOptionalAction,
        help="whether you want to init a new extension",
    )
    args = parser.parse_args()
    cli_version = parse(args.cli_version)

    repo = git.Repo(Path(".").resolve(), search_parent_directories=True)
    # Workaround for https://github.com/gitpython-developers/GitPython/issues/1923
    author = repo.config_reader().get_value("user", "name").lstrip('"').rstrip('"')
    email = repo.config_reader().get_value("user", "email").lstrip('"').rstrip('"')
    actor = git.Actor(author, email)

    index = get_extension_index(args.cache_dir)
    assert index["formatVersion"] == "1"  # only support formatVersion 1
    extensions_remote = index["extensions"]

    # init just prints the json of the extension version that matches the cli version.
    if args.init:
        if not args.extension:
            logger.error("extension name is required for --init")
            exit(1)

        for ext_name, ext_versions in extensions_remote.items():
            if ext_name != args.extension:
                continue
            ext = find_extension_version(
                ext_versions,
                cli_version,
                args.extension,
                requirements=True,
            )
            break
        if not ext:
            logger.error(f"Extension {args.extension} not found in index")
            exit(1)

        ext_translated = {
            "pname": ext["metadata"]["name"],
            "version": ext["metadata"]["version"],
            "url": ext["downloadUrl"],
            "hash": _convert_hash_digest_from_hex_to_b64_sri(ext["sha256Digest"]),
            "description": ext["metadata"]["summary"].rstrip("."),
            "license": ext["metadata"]["license"],
            "requirements": ext["metadata"]["run_requires"][0]["requires"],
        }
        print(json.dumps(ext_translated, indent=2))
        return

    if args.extension:
        logger.info(f"updating extension: {args.extension}")

        ext = Optional[Ext]
        for _ext_name, extension in extensions_remote.items():
            extension = find_and_transform_extension_version(
                extension, cli_version, args.extension, requirements=True
            )
            if extension:
                ext = extension
                break
        if not ext:
            logger.error(f"Extension {args.extension} not found in index")
            exit(1)

        version_pos = nix_unsafe_get_attr_pos(
            "version", f"azure-cli-extensions.{ext.pname}"
        )
        if not version_pos:
            logger.error(
                f"no position for attribute 'version' found on attribute path {ext.pname}"
            )
            exit(1)
        version = read_value_at_pos(version_pos)
        current_version = parse(version)

        if ext.version == current_version:
            logger.info(
                f"no update needed for {ext.pname}, latest version is {ext.version}"
            )
            return
        logger.info("updated extensions:")
        logger.info(f"  {ext.pname} {current_version} -> {ext.version}")
        edit_file_at_pos(version_pos, replace_value_in_nix_line(str(ext.version)))

        current_hash = nix_get_value(f"azure-cli-extensions.{ext.pname}.src.outputHash")
        if not current_hash:
            logger.error(
                f"no attribute 'src.outputHash' found on attribute path {ext.pname}"
            )
            exit(1)
        edit_file(version_pos.file, lambda line: line.replace(current_hash, ext.hash))

        if args.commit:
            commit_msg = (
                f"azure-cli-extensions.{ext.pname}: {current_version} -> {ext.version}"
            )
            _commit(repo, commit_msg, [Path(version_pos.file)], actor)
        return

    logger.info("updating generated extension set")

    extensions_remote_filtered = set()
    for _ext_name, extension in extensions_remote.items():
        extension = find_and_transform_extension_version(
            extension, cli_version, args.extension
        )
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
