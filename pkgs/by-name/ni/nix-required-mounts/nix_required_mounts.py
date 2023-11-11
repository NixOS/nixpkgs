#!/usr/bin/env python3

import glob
import json
import subprocess
import textwrap
from argparse import ArgumentParser
from itertools import chain
from pathlib import Path
from sys import stderr
from typing import Dict, List, Tuple, TypeAlias, TypedDict

Glob: TypeAlias = str
PathString: TypeAlias = str


class Mount(TypedDict):
    host: PathString
    guest: PathString


class Pattern(TypedDict):
    onFeatures: List[str]
    paths: List[Glob | Mount]


class HookConfig(TypedDict):
    nixExe: str
    allowedPatterns: Dict[str, Pattern]


parser = ArgumentParser("pre-build-hook")
parser.add_argument("derivation_path")
parser.add_argument("sandbox_path", nargs="?")
parser.add_argument("--config", type=Path)
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


def symlink_parents(p: Path) -> List[Path]:
    out = []
    while p.is_symlink() and p not in out:
        p = p.readlink()
        out.append(p)
    return out


def get_strings(drv_env: dict, name: str) -> List[str]:
    if "__json" in drv_env:
        return list(json.loads(drv_env["__json"]).get(name, []))
    else:
        return drv_env.get(name, "").split()


def entrypoint():
    args = parser.parse_args()
    drv_path = args.derivation_path

    with open(args.config, "r") as f:
        config = json.load(f)

    if not Path(drv_path).exists():
        print(
            f"[E] {drv_path} doesn't exist."
            " Cf. https://github.com/NixOS/nix/issues/9272"
            " Exiting the hook",
            file=stderr,
        )

    proc = subprocess.run(
        [
            config["nixExe"],
            "show-derivation",
            drv_path,
        ],
        capture_output=True,
    )
    try:
        parsed_drv = json.loads(proc.stdout)
    except json.JSONDecodeError:
        print(
            "[E] Couldn't parse the output of"
            "`nix show-derivation`"
            f". Expected JSON, observed: {proc.stdout}",
            file=stderr,
        )
        print(
            textwrap.indent(proc.stdout.decode("utf8"), prefix=" " * 4),
            file=stderr,
        )
        print("[I] Exiting the nix-required-binds hook", file=stderr)
        return
    [canon_drv_path] = parsed_drv.keys()

    allowed_patterns = config["allowedPatterns"]
    known_features = set(
        chain.from_iterable(
            pattern["onFeatures"] for pattern in allowed_patterns.values()
        )
    )

    parsed_drv = parsed_drv[canon_drv_path]
    drv_env = parsed_drv.get("env", {})
    features = get_strings(drv_env, "requiredSystemFeatures")
    features = list(filter(known_features.__contains__, features))

    patterns: List[PathString | Mount] = list(
        chain.from_iterable(allowed_patterns[f]["paths"] for f in features)
    )  # noqa: E501

    # TODO: Would it make sense to preserve the original order instead?
    roots: List[Tuple[PathString, PathString]] = sorted(
        set(
            mnt
            for pattern in patterns
            for mnt in (
                ((path, path) for path in glob.glob(pattern))
                if isinstance(pattern, PathString)
                else [(pattern["guest"], pattern["host"])]
            )
        )
    )

    # the pre-build-hook command
    if args.issue_command == "always" or (
        args.issue_command == "conditional" and roots
    ):
        print("extra-sandbox-paths")

    # arguments, one per line
    for guest_path, host_path in roots:
        print(f"{guest_path}={host_path}")

    # terminated by an empty line
    something_to_terminate = args.issue_stop == "conditional" and roots
    if args.issue_stop == "always" or something_to_terminate:
        print()


if __name__ == "__main__":
    entrypoint()
