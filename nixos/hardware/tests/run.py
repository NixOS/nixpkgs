#!/usr/bin/env nix-shell
#!nix-shell --quiet -p nix -p python3 -i python

import argparse
import multiprocessing
import re
import subprocess
import sys
from functools import partial
from pathlib import Path
from typing import List, Tuple

TEST_ROOT = Path(__file__).resolve().parent
ROOT = TEST_ROOT.parent

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"


def parse_readme() -> List[str]:
    profiles = set()
    with open(ROOT.joinpath("README.md")) as f:
        for line in f:
            results = re.findall(r"<nixos-hardware/[^>]+>", line)
            profiles.update(results)
    return list(profiles)


def build_profile(
    profile: str, verbose: bool
) -> Tuple[str, subprocess.CompletedProcess]:
    # Hard-code this for now until we have enough other architectures to care about this.
    system = "x86_64-linux"
    if "raspberry-pi/2" in profile:
        system = "armv7l-linux"

    cmd = [
        "nix",
        "build",
        "-f",
        "build-profile.nix",
        "-I",
        f"nixos-hardware={ROOT}",
        "--show-trace",
        "--system",
        system,
        "--arg",
        "profile",
        profile,
    ]

    # uses import from derivation
    if profile != "<nixos-hardware/toshiba/swanky>":
        cmd += ["--dry-run"]
    if verbose:
        print(f"$ {' '.join(cmd)}")
    res = subprocess.run(
        cmd, cwd=TEST_ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
    )
    return (profile, res)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run hardware tests")
    parser.add_argument(
        "--jobs",
        type=int,
        default=multiprocessing.cpu_count(),
        help="Number of parallel evaluations."
        "If set to 1 it disable multi processing (suitable for debugging)",
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Print evaluation commands executed",
    )
    parser.add_argument("profiles", nargs="*")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if len(args.profiles) == 0:
        profiles = parse_readme()
    else:
        profiles = args.profiles

    failed_profiles = []

    def eval_finished(args: Tuple[str, subprocess.CompletedProcess]) -> None:
        profile, res = args
        if res.returncode == 0:
            print(f"{GREEN}OK {profile}{RESET}")
        else:
            print(f"{RED}FAIL {profile}:{RESET}", file=sys.stderr)
            if res.stdout != "":
                print(f"{RED}{res.stdout.rstrip()}{RESET}", file=sys.stderr)
            print(f"{RED}{res.stderr.rstrip()}{RESET}", file=sys.stderr)
            failed_profiles.append(profile)

    build = partial(build_profile, verbose=args.verbose)
    if len(profiles) == 0 or args.jobs == 1:
        for profile in profiles:
            eval_finished(build(profile))
    else:
        pool = multiprocessing.Pool(processes=args.jobs)
        for r in pool.imap(build, profiles):
            eval_finished(r)
    if len(failed_profiles) > 0:
        print(f"\n{RED}The following {len(failed_profiles)} test(s) failed:{RESET}")
        for profile in failed_profiles:
            print(f"{sys.argv[0]} '{profile}'")
        sys.exit(1)


if __name__ == "__main__":
    main()
