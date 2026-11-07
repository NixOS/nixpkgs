#!/usr/bin/env python3

import json
import subprocess
import sys


USAGE = """Usage:
  facter-changes --flake <flake-config-ref>
  facter-changes -F <flake-config-ref>
  facter-changes -I nixos-config=./configuration.nix [nix-instantiate args...]

Examples:
  facter-changes --flake .#nixosConfigurations.badxps
  facter-changes -I nixos-config=./configuration.nix
"""

FLAKE_SUFFIX = ".config.hardware.facter.debug.changes"


def print_usage(stream) -> None:
    stream.write(USAGE)


def normalize_flake_target(target: str) -> str:
    if target.endswith(FLAKE_SUFFIX):
        return target[: -len(FLAKE_SUFFIX)]
    return target


def run_command(args: list[str], *, suppress_stderr: bool = False) -> str:
    result = subprocess.run(
        args,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL if suppress_stderr else None,
        text=True,
    )
    return result.stdout.strip()


def try_run_command(args: list[str]) -> str | None:
    try:
        return run_command(args, suppress_stderr=True)
    except subprocess.CalledProcessError:
        return None


def eval_flake_changes(target: str) -> dict[str, object]:
    output = run_command(
        ["nix", "eval", "--json", f"{target}.config.hardware.facter.changes"]
    )
    return json.loads(output)


def eval_flake_value(target: str, option: str) -> str | None:
    return try_run_command(["nix", "eval", "--json", f"{target}.config.{option}"])


def eval_legacy_changes(legacy_args: list[str]) -> dict[str, object]:
    output = run_command(
        [
            "nix-instantiate",
            "<nixpkgs/nixos>",
            "--eval",
            "--strict",
            "--json",
            "-A",
            "config.hardware.facter.changes",
            *legacy_args,
        ]
    )
    return json.loads(output)


def eval_legacy_value(option: str, legacy_args: list[str]) -> str | None:
    return try_run_command(
        [
            "nix-instantiate",
            "<nixpkgs/nixos>",
            "--eval",
            "--strict",
            "--json",
            "-A",
            f"config.{option}",
            *legacy_args,
        ]
    )


def to_json(value: object) -> str:
    return json.dumps(value, separators=(",", ":"))


def parse_args(argv: list[str]) -> tuple[str, str | list[str]]:
    if not argv:
        raise ValueError("missing arguments")

    if argv[0] in ("--help", "-h"):
        print_usage(sys.stdout)
        raise SystemExit(0)

    if argv[0] in ("--flake", "-F"):
        if len(argv) != 2:
            raise ValueError("flake mode expects exactly one target")
        return ("flake", normalize_flake_target(argv[1]))

    return ("legacy", argv)


def main(argv: list[str]) -> int:
    try:
        mode, parsed_args = parse_args(argv)
    except ValueError as exc:
        sys.stderr.write(f"facter-changes: {exc}\n")
        print_usage(sys.stderr)
        return 1

    if mode == "flake":
        flake_target = parsed_args
        changes = eval_flake_changes(flake_target)
        value_loader = lambda option: eval_flake_value(flake_target, option)
    else:
        legacy_args = parsed_args
        changes = eval_legacy_changes(legacy_args)
        value_loader = lambda option: eval_legacy_value(option, legacy_args)

    for option, desired_value in changes.items():
        effective_json = value_loader(option)

        if isinstance(desired_value, dict):
            for source, source_value in desired_value.items():
                print(f"# facter {source} = {to_json(source_value)}")
        else:
            print(f"# facter {option} = {to_json(desired_value)}")

        if effective_json is None:
            print(f"{option} = <unavailable>")
        else:
            print(f"{option} = {effective_json}")

        print()

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
