"""Update tool for Nixpkgs OpenJDK packages."""

import argparse
import json
import os
import re
import subprocess
from pathlib import Path
from typing import Literal

import github
from pydantic import BaseModel


class SourceInfo(BaseModel):
    """GitHub fetcher data for an OpenJDK release tag."""

    owner: str
    repo: str
    rev: str
    hash: str


type Update = tuple[int, ...]
type Build = int | Literal["ga"]


def parse_openjdk_ref_name(
    feature_version_prefix: str,
    ref_name: str,
) -> tuple[Update, Build]:
    r"""Parse an OpenJDK Git ref name containing a JDK version.

    Takes the tag name prefix for a given feature version and parses
    the rest of the version and build information.

    See |java.lang.Runtime.Version|_ for documentation of the modern
    version string scheme initially introduced in `JEP 223`_ for JDK 9,
    though this tool also supports JDK 8 for now.

    .. |java.lang.Runtime.Version| replace:: ``java.lang.Runtime.Version``
    .. _java.lang.Runtime.Version: https://docs.oracle.com/en/java/javase/23/docs/api/java.base/java/lang/Runtime.Version.html
    .. _JEP 223: https://openjdk.org/jeps/223

    >>> parse_openjdk_ref_name("jdk-23", "refs/tags/jdk-23-ga")
    ((), 'ga')
    >>> parse_openjdk_ref_name("jdk-17", "refs/tags/jdk-17.0.2+7")
    ((0, 2), 7)
    >>> parse_openjdk_ref_name("jdk8", "refs/tags/jdk8u422-ga")
    ((422,), 'ga')
    >>> parse_openjdk_ref_name("jdk8", "refs/tags/jdk8-b01")
    ((), 1)
    >>> parse_openjdk_ref_name("22", "refs/tags/22.0.2-ga")
    ((0, 2), 'ga')
    >>> parse_openjdk_ref_name("jdk8", "refs/tags/jdk7-b147")
    Traceback (most recent call last):
    ...
    ValueError: unexpected OpenJDK ref name: refs/tags/jdk7-b147
    >>> parse_openjdk_ref_name("jdk8", "refs/tags/jdk80-ga")
    Traceback (most recent call last):
    ...
    ValueError: unexpected OpenJDK ref name: refs/tags/jdk80-ga
    >>> parse_openjdk_ref_name("11", "refs/tags/jdk-11+14")
    Traceback (most recent call last):
    ...
    ValueError: unexpected OpenJDK ref name: refs/tags/jdk-11+14
    """
    m = re.fullmatch(
        rf"""
            refs/tags/{re.escape(feature_version_prefix)}
            (?P<update>
                (?:u[0-9]+)? # JDK 8 uses u
                | (?:\.[0-9]+)*
            )
            (?P<build>
                -ga
                | (\+|-b) # JDK 8 uses -b
                [0-9]+
            )
        """,
        ref_name,
        re.VERBOSE,
    )
    if not m:
        msg = f"unexpected OpenJDK ref name: {ref_name}"
        raise ValueError(msg)
    update = tuple(
        int(element) for element in m["update"].replace("u", ".").split(".")[1:]
    )
    build = (
        "ga"
        if m["build"] == "-ga"
        else int(m["build"].removeprefix("+").removeprefix("-b"))
    )
    return update, build


def main() -> None:
    """Update a Nixpkgs OpenJDK package."""
    parser = argparse.ArgumentParser(description=main.__doc__)
    parser.add_argument("--source-file", type=Path, required=True)
    parser.add_argument("--owner", required=True)
    parser.add_argument("--repo", required=True)
    parser.add_argument("--feature-version-prefix", required=True)
    args = parser.parse_args()

    source_info: SourceInfo | None
    try:
        with args.source_file.open() as source_fp:
            source_info = SourceInfo(**json.load(source_fp))
    except FileNotFoundError:
        source_info = None

    token = os.environ.get("GITHUB_TOKEN")
    gh = github.Github(auth=github.Auth.Token(token) if token else None)

    repo = gh.get_repo(f"{args.owner}/{args.repo}")
    versions: dict[Update, dict[Build, str]] = {}
    for ref in repo.get_git_matching_refs(
        "tags/" + args.feature_version_prefix
    ):
        update, build = parse_openjdk_ref_name(
            args.feature_version_prefix,
            ref.ref,
        )
        versions.setdefault(update, {})[build] = ref.ref

    # We want a finalized General Availability release version, but we
    # want to pin a tag with the build number in it so that we can use
    # it for version information.
    #
    # The OpenJDK `-ga` tags point to the same commits as the highest
    # build number for a given version, so we find and pin that.
    latest_release_builds = versions[
        max(update for update, builds in versions.items() if "ga" in builds)
    ]
    latest_release_ref_name = latest_release_builds[
        max(latest_release_builds.keys() - {"ga"})
    ]

    if source_info and source_info.rev == latest_release_ref_name:
        return

    prefetch_result = subprocess.run(  # noqa: S603
        (
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "store",
            "prefetch-file",
            "--json",
            "--unpack",
            "--name",
            "source",
            repo.get_archive_link("tarball", latest_release_ref_name),
        ),
        check=True,
        stdout=subprocess.PIPE,
    )
    source_info = SourceInfo(
        owner=args.owner,
        repo=args.repo,
        rev=latest_release_ref_name,
        hash=json.loads(prefetch_result.stdout)["hash"],
    )
    with args.source_file.open("w") as source_fp:
        json.dump(
            source_info.model_dump(),
            source_fp,
            indent="  ",
            sort_keys=True,
        )
        print(file=source_fp)
