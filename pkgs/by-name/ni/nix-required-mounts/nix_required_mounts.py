import glob
import json
import os
import subprocess
import textwrap
from argparse import ArgumentParser
from collections import deque
from itertools import chain
from pathlib import Path, PurePath
from typing import (
    TypeAlias,
    TypedDict,
    Iterable,
)
import logging

Glob: TypeAlias = str
PathString: TypeAlias = str


class Mount(TypedDict):
    host: PathString
    guest: PathString


class Pattern(TypedDict):
    onFeatures: list[str]
    paths: list[Glob | Mount]
    unsafeFollowSymlinks: bool
    safePrefixes: list[str]


AllowedPatterns: TypeAlias = dict[str, Pattern]


parser = ArgumentParser("pre-build-hook")
parser.add_argument("derivation_path")
parser.add_argument("sandbox_path", nargs="?")
parser.add_argument("--patterns", type=Path, required=True)
parser.add_argument("--nix-exe", type=Path)
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


def parse_derivation(
    derivation_path: PathString, nix_exe: PathString | None
) -> dict:
    """Extract the content of a .drv file into a JSON dict"""
    if not Path(derivation_path).exists():
        logging.error(
            f"{derivation_path} doesn't exist."
            " Cf. https://github.com/NixOS/nix/issues/9272"
            " Exiting the hook",
        )

    proc = subprocess.run(
        [
            nix_exe if nix_exe else "nix",
            "show-derivation",
            derivation_path,
        ],
        capture_output=True,
    )
    try:
        parsed_drv = json.loads(proc.stdout)

        # compabitility: https://github.com/NixOS/nix/pull/14770
        if "derivations" in parsed_drv:
            parsed_drv = parsed_drv["derivations"]
    except json.JSONDecodeError:
        output_str: str = proc.stdout.decode("utf-8")
        logging.error(
            "Couldn't parse the output of"
            "`nix show-derivation`"
            f". Expected JSON, observed: {output_str}",
        )
        logging.error(textwrap.indent(output_str, prefix=" " * 4))
        logging.info("Exiting the nix-required-binds hook")

    [canon_drv_path] = parsed_drv.keys()

    return parsed_drv[canon_drv_path]


def get_required_system_features(parsed_drv: dict) -> set[str]:
    # Newer versions of Nix (since https://github.com/NixOS/nix/pull/13263)
    # store structuredAttrs in the derivation JSON output.
    if "structuredAttrs" in parsed_drv:
        return set(
            parsed_drv["structuredAttrs"].get("requiredSystemFeatures", [])
        )

    # Older versions of Nix store structuredAttrs in the env as a JSON string.
    drv_env = parsed_drv.get("env", {})
    if "__json" in drv_env:
        return set(
            json.loads(drv_env["__json"]).get("requiredSystemFeatures", [])
        )

    # Without structuredAttrs, requiredSystemFeatures is a space-separated string in env.
    return set(drv_env.get("requiredSystemFeatures", "").split())


def expand_globs(paths: list[PathString]) -> list[PathString]:
    """Expand all existing paths from globbed paths like bash would"""
    return sum(map(glob.glob, paths), [])


def symlink_targets(p: Path) -> list[Path]:
    """Traverse a chain of symlinks to collect every intermediate path up to the final destination."""

    out = []
    while p.is_symlink():
        target = p.readlink()
        if target.is_absolute():
            p = target
        else:
            # we need to resolve paths before concatenation because of things like
            # $ ls -l /sys/dev/char/226:128/subsystem
            # ... /sys/dev/char/226:128/subsystem
            # -> ../../../../../../class/drm
            #
            # Path(normpath(...)) needed to normalize `foo/../bar` to `bar`
            p = Path(os.path.normpath(p.parent.resolve() / target))

        if p in out:
            break
        out.append(p)

    return out


def symlink_targets_deep(
    inputs: Iterable[PathString], follow_symlinks: bool
) -> list[PathString]:
    """Walk the file system tree and discover all possible symlink targets"""
    queue: deque[PathString] = deque(inputs)
    unique_paths: set[PathString] = set()
    reachable_paths: list[PathString] = []

    while queue:
        path_str = str(queue.popleft())
        if path_str not in unique_paths:
            reachable_paths.append(path_str)
            unique_paths.add(path_str)

        if not follow_symlinks:
            continue

        path = Path(path_str)
        if not (path.is_dir() or path.is_symlink()):
            continue

        paths: Iterable[Path] = [path]
        if path.is_dir():
            paths = chain(paths, path.iterdir())

        for child in paths:
            for parent in symlink_targets(child):
                path = parent.absolute()
                if all(
                    not path.is_relative_to(existing_path)
                    for existing_path in unique_paths
                ):
                    queue.append(path.as_posix())
    return reachable_paths


def prune_paths(inputs: Iterable[PathString]) -> list[PathString]:
    """
    From a list of paths prune all paths that are subdirectories of others

    >>> prune_paths(["/a/b", "/a"])
    ['/a']
    >>> prune_paths(["/a/b/c", "/a/b"])
    ['/a/b']
    """
    sorted_inputs = sorted(inputs)
    pruned = [sorted_inputs[0]]

    last_kept: PathString = pruned[0]
    for current in sorted_inputs[1:]:
        if not Path(current).is_relative_to(last_kept):
            pruned.append(current)
            last_kept = current

    return pruned


def mount_closure(pattern: Pattern) -> list[tuple[PathString, PathString]]:
    """
    This function extracts all paths from a pattern into the following:
    - list of nix store paths
    - host/hardware specific paths (anything outside the nix store)
    - translations from host to guest (necessary for some non-NixOS hosts)

    As the host paths are often multiple levels of symlinks, these can be
    followed to be able to provide them all in the sandbox as they would
    otherwise be broken (see `unsafeFollowSymlinks`).

    The finally returned list contains tuples with guest-host mappings between
    those paths. Most of them are 1:1.
    """

    def safe_prefix(p):
        safe_prefixes = pattern.get("safePrefixes", [])
        return any(p.startswith(safe_prefix) for safe_prefix in safe_prefixes)

    # All nix store paths have been statically calculated before.
    # There is no need to look into them or add anything
    store_paths = [
        p
        for p in pattern["paths"]
        if isinstance(p, PathString) and safe_prefix(p)
    ]
    # Paths that e.g. point to /dev/... or /run/... paths etc. might further
    # point to other paths and these need to be added to the sandbox, too.
    host_paths = [
        p
        for p in pattern["paths"]
        if isinstance(p, PathString) and not safe_prefix(p)
    ]
    # Translations on the non-NixOS hosts like e.g. /usr/lib to /run/opengl-driver
    # need to be applied on the final path list
    translations: dict[PathString, PathString] = {
        p["host"]: p["guest"]
        for p in pattern["paths"]
        if not isinstance(p, PathString)
    }

    host_paths.extend(translations.keys())

    all_paths = prune_paths(
        chain(
            store_paths,
            symlink_targets_deep(
                expand_globs(host_paths), pattern["unsafeFollowSymlinks"]
            ),
        )
    )

    return [(translations.get(x, x), x) for x in all_paths]


def patterns_for_features(
    patterns: AllowedPatterns, features: set[str]
) -> AllowedPatterns:
    """
    Return the list of patterns that are required for a given set of features.
    >>> patterns = {
    ...   "a": {
    ...     "onFeatures": ["a"],
    ...     "unsafeFollowSymlinks": True,
    ...     "paths": []
    ...   },
    ...   "b": {
    ...     "onFeatures": ["b"],
    ...     "unsafeFollowSymlinks": True,
    ...     "paths": []
    ...   }
    ... }
    >>> list(patterns_for_features(patterns, {"a"}).keys())
    ['a']
    >>> list(patterns_for_features(patterns, {"a", "b"}).keys())
    ['a', 'b']
    """
    return {
        k: v for k, v in patterns.items() if set(v["onFeatures"]) & features
    }


def entrypoint() -> None:
    args = parser.parse_args()

    VERBOSITY_LEVELS = [logging.ERROR, logging.INFO, logging.DEBUG]

    level_index = min(args.verbose, len(VERBOSITY_LEVELS) - 1)
    logging.basicConfig(level=VERBOSITY_LEVELS[level_index])

    with open(args.patterns, "r") as f:
        patterns = json.load(f)

    parsed_drv: dict = parse_derivation(args.derivation_path, args.nix_exe)
    features: set[str] = get_required_system_features(parsed_drv)
    required_patterns: AllowedPatterns = patterns_for_features(
        patterns, features
    )

    mounts = list(
        chain.from_iterable(
            (mount_closure(pattern) for pattern in required_patterns.values())
        )
    )

    # the pre-build-hook command
    if args.issue_command == "always" or (
        args.issue_command == "conditional" and mounts
    ):
        print("extra-sandbox-paths")
        for guest_path_str, host_path_str in mounts:
            print(f"{guest_path_str}={host_path_str}")

    # terminated by an empty line
    something_to_terminate = args.issue_stop == "conditional" and mounts
    if args.issue_stop == "always" or something_to_terminate:
        print()


if __name__ == "__main__":
    entrypoint()
