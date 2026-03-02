#!/usr/bin/env python3

import glob
import json
import subprocess
import textwrap
from argparse import ArgumentParser
from collections import deque
from itertools import chain
from pathlib import Path
from typing import Deque, Dict, List, Set, Tuple, TypeAlias, TypedDict
import logging

Glob: TypeAlias = str
PathString: TypeAlias = str


class Mount(TypedDict):
    host: PathString
    guest: PathString


class Pattern(TypedDict):
    onFeatures: List[str]
    paths: List[Glob | Mount]
    unsafeFollowSymlinks: bool


AllowedPatterns: TypeAlias = Dict[str, Pattern]


parser = ArgumentParser("pre-build-hook")
parser.add_argument("derivation_path")
parser.add_argument("sandbox_path", nargs="?")
parser.add_argument("--patterns", type=Path, required=True)
parser.add_argument("--nix-exe", type=Path, required=True)
parser.add_argument(
    "--issue-command",
    choices=("always", "conditional", "never"),
    default="conditional",
    help="Whether to print extra-sandbox-paths",
)
parser.add_argument(
    "--issue-stop",
    choices=("always", "conditional", "never"),
    default="conditional",
    help="Whether to print the final empty line",
)
parser.add_argument("-v", "--verbose", action="count", default=0)


def symlink_parents(p: Path) -> List[Path]:
    out = []
    while p.is_symlink() and p not in out:
        parent = p.readlink()
        if parent.is_relative_to("."):
            p = p / parent
        else:
            p = parent
        out.append(p)
    return out


def get_required_system_features(parsed_drv: dict) -> List[str]:
    # Newer versions of Nix (since https://github.com/NixOS/nix/pull/13263) store structuredAttrs
    # in the derivation JSON output.
    if "structuredAttrs" in parsed_drv:
        return parsed_drv["structuredAttrs"].get("requiredSystemFeatures", [])

    # Older versions of Nix store structuredAttrs in the env as a JSON string.
    drv_env = parsed_drv.get("env", {})
    if "__json" in drv_env:
        return list(json.loads(drv_env["__json"]).get("requiredSystemFeatures", []))

    # Without structuredAttrs, requiredSystemFeatures is a space-separated string in env.
    return drv_env.get("requiredSystemFeatures", "").split()


def validate_mounts(pattern: Pattern) -> List[Tuple[PathString, PathString, bool]]:
    roots = []
    for mount in pattern["paths"]:
        if isinstance(mount, PathString):
            matches = glob.glob(mount)
            assert matches, f"Specified host paths do not exist: {mount}"

            roots.extend((m, m, pattern["unsafeFollowSymlinks"]) for m in matches)
        else:
            assert isinstance(mount, dict) and "host" in mount, mount
            assert Path(
                mount["host"]
            ).exists(), f"Specified host paths do not exist: {mount['host']}"
            roots.append(
                (
                    mount["guest"],
                    mount["host"],
                    pattern["unsafeFollowSymlinks"],
                )
            )

    return roots


def entrypoint():
    args = parser.parse_args()

    VERBOSITY_LEVELS = [logging.ERROR, logging.INFO, logging.DEBUG]

    level_index = min(args.verbose, len(VERBOSITY_LEVELS) - 1)
    logging.basicConfig(level=VERBOSITY_LEVELS[level_index])

    drv_path = args.derivation_path

    with open(args.patterns, "r") as f:
        allowed_patterns = json.load(f)

    if not Path(drv_path).exists():
        logging.error(
            f"{drv_path} doesn't exist."
            " Cf. https://github.com/NixOS/nix/issues/9272"
            " Exiting the hook",
        )

    proc = subprocess.run(
        [
            args.nix_exe,
            "show-derivation",
            drv_path,
        ],
        capture_output=True,
    )
    try:
        parsed_drv = json.loads(proc.stdout)
    except json.JSONDecodeError:
        logging.error(
            "Couldn't parse the output of"
            "`nix show-derivation`"
            f". Expected JSON, observed: {proc.stdout}",
        )
        logging.error(textwrap.indent(proc.stdout.decode("utf8"), prefix=" " * 4))
        logging.info("Exiting the nix-required-binds hook")
        return
    [canon_drv_path] = parsed_drv.keys()

    known_features = set(
        chain.from_iterable(
            pattern["onFeatures"] for pattern in allowed_patterns.values()
        )
    )

    parsed_drv = parsed_drv[canon_drv_path]
    required_features = get_required_system_features(parsed_drv)
    required_features = list(filter(known_features.__contains__, required_features))

    patterns: List[Pattern] = list(
        pattern
        for pattern in allowed_patterns.values()
        for path in pattern["paths"]
        if any(feature in required_features for feature in pattern["onFeatures"])
    )  # noqa: E501

    queue: Deque[Tuple[PathString, PathString, bool]] = deque(
        (mnt for pattern in patterns for mnt in validate_mounts(pattern))
    )

    unique_mounts: Set[Tuple[PathString, PathString]] = set()
    mounts: List[Tuple[PathString, PathString]] = []

    while queue:
        guest_path_str, host_path_str, follow_symlinks = queue.popleft()
        if (guest_path_str, host_path_str) not in unique_mounts:
            mounts.append((guest_path_str, host_path_str))
            unique_mounts.add((guest_path_str, host_path_str))

        if not follow_symlinks:
            continue

        host_path = Path(host_path_str)
        if not (host_path.is_dir() or host_path.is_symlink()):
            continue

        # assert host_path_str == guest_path_str, (host_path_str, guest_path_str)

        for child in host_path.iterdir() if host_path.is_dir() else [host_path]:
            for parent in symlink_parents(child):
                parent_str = parent.absolute().as_posix()
                queue.append((parent_str, parent_str, follow_symlinks))

    # the pre-build-hook command
    if args.issue_command == "always" or (
        args.issue_command == "conditional" and mounts
    ):
        print("extra-sandbox-paths")
        print_paths = True
    else:
        print_paths = False

    # arguments, one per line
    for guest_path_str, host_path_str in mounts if print_paths else []:
        print(f"{guest_path_str}={host_path_str}")

    # terminated by an empty line
    something_to_terminate = args.issue_stop == "conditional" and mounts
    if args.issue_stop == "always" or something_to_terminate:
        print()


if __name__ == "__main__":
    entrypoint()
