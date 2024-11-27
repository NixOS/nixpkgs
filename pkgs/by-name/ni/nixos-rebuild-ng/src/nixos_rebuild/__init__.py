from __future__ import annotations

import argparse
import json
import os
import sys
from subprocess import run
from typing import assert_never

from .models import Action, Flake, NRError, Profile
from .nix import (
    edit,
    find_file,
    get_nixpkgs_rev,
    list_generations,
    nixos_build,
    nixos_build_flake,
    rollback,
    rollback_temporary_profile,
    set_profile,
    switch_to_configuration,
    upgrade_channels,
)
from .utils import info

VERBOSE = False


def parse_args(argv: list[str]) -> tuple[argparse.Namespace, list[str]]:
    parser = argparse.ArgumentParser(
        prog="nixos-rebuild",
        description="Reconfigure a NixOS machine",
        add_help=False,
        allow_abbrev=False,
    )
    parser.add_argument("--help", action="store_true")
    parser.add_argument("--file", "-f")
    parser.add_argument("--attr", "-A")
    parser.add_argument("--flake", nargs="?", const=True)
    parser.add_argument("--no-flake", dest="flake", action="store_false")
    parser.add_argument("--install-bootloader", action="store_true")
    # TODO: add deprecated=True in Python >=3.13
    parser.add_argument("--install-grub", action="store_true")
    parser.add_argument("--profile-name", "-p", default="system")
    parser.add_argument("--specialisation", "-c")
    parser.add_argument("--rollback", action="store_true")
    parser.add_argument("--upgrade", action="store_true")
    parser.add_argument("--upgrade-all", action="store_true")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("action", choices=Action.values(), nargs="?")

    args, remainder = parser.parse_known_args(argv[1:])

    global VERBOSE
    # Manually parse verbose flag since this is a nix flag that also affect
    # the script
    VERBOSE = any(v == "--verbose" or v.startswith("-v") for v in remainder)

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L56
    if args.action == Action.DRY_RUN.value:
        args.action = Action.DRY_BUILD.value

    if args.install_grub:
        info(
            f"{parser.prog}: warning: --install-grub deprecated, use --install-bootloader instead"
        )
        args.install_bootloader = True

    if args.action == Action.EDIT.value and (args.file or args.attr):
        parser.error("--file and --attr are not supported with 'edit'")

    if args.flake and (args.file or args.attr):
        parser.error("--flake cannot be used with --file or --attr")

    if args.help or args.action is None:
        r = run(["man", "8", "nixos-rebuild"], check=False)
        parser.exit(r.returncode)

    return args, remainder


def execute(argv: list[str]) -> None:
    args, nix_flags = parse_args(argv)

    profile = Profile.from_name(args.profile_name)
    flake = Flake.from_arg(args.flake)

    if args.upgrade or args.upgrade_all:
        upgrade_channels(bool(args.upgrade_all))

    action = Action(args.action)
    # Only run shell scripts from the Nixpkgs tree if the action is
    # "switch", "boot", or "test". With other actions (such as "build"),
    # the user may reasonably expect that no code from the Nixpkgs tree is
    # executed, so it's safe to run nixos-rebuild against a potentially
    # untrusted tree.
    can_run = action in (Action.SWITCH, Action.BOOT, Action.TEST)
    if can_run and not flake:
        nixpkgs_path = find_file("nixpkgs", nix_flags)
        rev = get_nixpkgs_rev(nixpkgs_path)
        if nixpkgs_path and rev:
            (nixpkgs_path / ".version-suffix").write_text(rev)

    match action:
        case Action.SWITCH | Action.BOOT:
            info("building the system configuration...")
            if args.rollback:
                path_to_config = rollback(profile)
            elif flake:
                path_to_config = nixos_build_flake(
                    "toplevel",
                    flake,
                    nix_flags,
                    no_link=True,
                )
                set_profile(profile, path_to_config)
            else:
                path_to_config = nixos_build(
                    "system",
                    args.attr,
                    args.file,
                    nix_flags,
                    no_out_link=True,
                )
                set_profile(profile, path_to_config)
            switch_to_configuration(
                path_to_config,
                action,
                specialisation=args.specialisation,
                install_bootloader=args.install_bootloader,
            )
        case Action.TEST | Action.BUILD | Action.DRY_BUILD | Action.DRY_ACTIVATE:
            info("building the system configuration...")
            dry_run = action == Action.DRY_BUILD
            if args.rollback and action in (Action.TEST, Action.BUILD):
                maybe_path_to_config = rollback_temporary_profile(profile)
                if maybe_path_to_config:  # kinda silly but this makes mypy happy
                    path_to_config = maybe_path_to_config
                else:
                    raise NRError("could not find previous generation")
            elif flake:
                path_to_config = nixos_build_flake(
                    "toplevel",
                    flake,
                    nix_flags,
                    keep_going=True,
                    dry_run=dry_run,
                )
            else:
                path_to_config = nixos_build(
                    "system",
                    args.attr,
                    args.file,
                    nix_flags,
                    keep_going=True,
                    dry_run=dry_run,
                )
            if action in (Action.TEST, Action.DRY_ACTIVATE):
                switch_to_configuration(
                    path_to_config,
                    action,
                    specialisation=args.specialisation,
                )
        case Action.BUILD_VM | Action.BUILD_VM_WITH_BOOTLOADER:
            info("building the system configuration...")
            attr = "vm" if action == Action.BUILD_VM else "vmWithBootLoader"
            if flake:
                path_to_config = nixos_build_flake(
                    attr,
                    flake,
                    nix_flags,
                    keep_going=True,
                )
            else:
                path_to_config = nixos_build(
                    attr,
                    args.attr,
                    args.file,
                    nix_flags,
                    keep_going=True,
                )
            vm_path = next(path_to_config.glob("bin/run-*-vm"), "./result/bin/run-*-vm")
            print(f"Done. The virtual machine can be started by running '{vm_path}'")
        case Action.EDIT:
            edit(flake, nix_flags)
        case Action.DRY_RUN:
            assert False, "DRY_RUN should be a DRY_BUILD alias"
        case Action.LIST_GENERATIONS:
            generations = list_generations(profile)
            if args.json:
                print(json.dumps(generations, indent=2))
            else:
                from tabulate import tabulate

                headers = {
                    "generation": "Generation",
                    "date": "Build-date",
                    "nixosVersion": "NixOS version",
                    "kernelVersion": "Kernel",
                    "configurationRevision": "Configuration Revision",
                    "specialisations": "Specialisation",
                    "current": "Current",
                }
                # Not exactly the same format as legacy nixos-rebuild but close
                # enough
                table = tabulate(
                    generations,
                    headers=headers,
                    tablefmt="plain",
                    numalign="left",
                    stralign="left",
                    disable_numparse=True,
                )
                print(table)
        case Action.REPL:
            # For now just redirect it to `nixos-rebuild` instead of
            # duplicating the code
            os.execv(
                "@nixos_rebuild@",
                argv,
            )
        case _:
            assert_never(action)


def main() -> None:
    try:
        execute(sys.argv)
    except (Exception, KeyboardInterrupt) as ex:
        if VERBOSE:
            raise ex
        else:
            sys.exit(str(ex))
