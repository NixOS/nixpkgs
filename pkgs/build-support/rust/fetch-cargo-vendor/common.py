import functools
import re
import sys
import tomllib
from pathlib import Path
from typing import Any, TypedDict, cast
from urllib.parse import unquote


eprint = functools.partial(print, file=sys.stderr)


def load_toml(path: Path) -> dict[str, Any]:
    with open(path, "rb") as f:
        return tomllib.load(f)


def get_lockfile_version(cargo_lock_toml: dict[str, Any]) -> int:
    # lockfile v1 and v2 don't have the `version` key, so assume v2
    version = cargo_lock_toml.get("version", 2)

    # TODO: add logic for differentiating between v1 and v2

    return version


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
