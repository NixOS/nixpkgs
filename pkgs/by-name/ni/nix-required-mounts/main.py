#!/usr/bin/env python3

import glob
import json
import subprocess
import textwrap
from argparse import ArgumentParser
from itertools import chain
from pathlib import Path
from sys import stderr
from typing import Dict, List, TypedDict


class Pattern(TypedDict):
    onFeatures: List[str]
    paths: List[str]  # List of glob patterns


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


def entrypoint():
    args = parser.parse_args()
    drv_path = args.derivation_path

    with open(args.config, "r") as f:
        config = json.load(f)

    if not Path(drv_path).exists():
        print(
            f"[E] {drv_path} doesn't exist."
            " This may happen with the remote builds."
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
        drv = json.loads(proc.stdout)
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
    [canon_drv_path] = drv.keys()

    allowed_patterns = config["allowedPatterns"]
    known_features = set(
        chain.from_iterable(
            pattern["onFeatures"] for pattern in allowed_patterns.values()
        )
    )

    drv_env = drv[canon_drv_path].get("env", {})
    features = drv_env.get("requiredSystemFeatures", [])
    if isinstance(features, str):
        features = features.split()

    features = list(filter(known_features.__contains__, features))

    patterns = list(
        chain.from_iterable(allowed_patterns[f]["paths"] for f in features)
    )  # noqa: E501

    roots = sorted(
        set(Path(path) for pattern in patterns for path in glob.glob(pattern))
    )

    # the pre-build-hook command
    if args.issue_command == "always" or (
        args.issue_command == "conditional" and roots
    ):
        print("extra-sandbox-paths")

    # arguments, one per line
    for p in roots:
        guest_path, host_path = p, p
        print(f"{guest_path}={host_path}")

    # terminated by an empty line
    something_to_terminate = args.issue_stop == "conditional" and roots
    if args.issue_stop == "always" or something_to_terminate:
        print()


if __name__ == "__main__":
    entrypoint()
