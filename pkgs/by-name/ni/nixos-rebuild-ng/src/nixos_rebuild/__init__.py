import argparse
import atexit
import json
import os
import sys
from pathlib import Path
from subprocess import run
from tempfile import TemporaryDirectory
from typing import assert_never

from . import nix
from .models import Action, Flake, NRError, Profile
from .process import Remote, cleanup_ssh
from .utils import info

VERBOSE = 0


def get_parser() -> tuple[argparse.ArgumentParser, dict[str, argparse.ArgumentParser]]:
    common_flags = argparse.ArgumentParser(add_help=False)
    common_flags.add_argument("--verbose", "-v", action="count", default=0)
    common_flags.add_argument("--max-jobs", "-j")
    common_flags.add_argument("--cores")
    common_flags.add_argument("--log-format")
    common_flags.add_argument("--keep-going", "-k", action="store_true")
    common_flags.add_argument("--keep-failed", "-K", action="store_true")
    common_flags.add_argument("--fallback", action="store_true")
    common_flags.add_argument("--repair", action="store_true")
    common_flags.add_argument("--option", nargs=2)

    common_build_flags = argparse.ArgumentParser(add_help=False)
    common_build_flags.add_argument("--include", "-I")
    common_build_flags.add_argument("--quiet", action="store_true")
    common_build_flags.add_argument("--print-build-logs", "-L", action="store_true")
    common_build_flags.add_argument("--show-trace", action="store_true")

    flake_build_flags = argparse.ArgumentParser(add_help=False)
    flake_build_flags.add_argument("--accept-flake-config", action="store_true")
    flake_build_flags.add_argument("--refresh", action="store_true")
    flake_build_flags.add_argument("--impure", action="store_true")
    flake_build_flags.add_argument("--offline", action="store_true")
    flake_build_flags.add_argument("--no-net", action="store_true")
    flake_build_flags.add_argument("--recreate-lock-file", action="store_true")
    flake_build_flags.add_argument("--no-update-lock-file", action="store_true")
    flake_build_flags.add_argument("--no-write-lock-file", action="store_true")
    flake_build_flags.add_argument("--no-registries", action="store_true")
    flake_build_flags.add_argument("--commit-lock-file", action="store_true")
    flake_build_flags.add_argument("--update-input")
    flake_build_flags.add_argument("--override-input", nargs=2)

    classic_build_flags = argparse.ArgumentParser(add_help=False)
    classic_build_flags.add_argument("--no-build-output", "-Q", action="store_true")

    copy_flags = argparse.ArgumentParser(add_help=False)
    copy_flags.add_argument("--use-substitutes", "-s", action="store_true")

    sub_parsers = {
        "common_flags": common_flags,
        "common_build_flags": common_build_flags,
        "flake_build_flags": flake_build_flags,
        "classic_build_flags": classic_build_flags,
        "copy_flags": copy_flags,
    }

    main_parser = argparse.ArgumentParser(
        prog="nixos-rebuild",
        parents=list(sub_parsers.values()),
        description="Reconfigure a NixOS machine",
        add_help=False,
        allow_abbrev=False,
    )
    main_parser.add_argument("--help", "-h", action="store_true")
    main_parser.add_argument("--file", "-f")
    main_parser.add_argument("--attr", "-A")
    main_parser.add_argument("--flake", nargs="?", const=True)
    main_parser.add_argument("--no-flake", dest="flake", action="store_false")
    main_parser.add_argument("--install-bootloader", action="store_true")
    main_parser.add_argument("--install-grub", action="store_true")  # deprecated
    main_parser.add_argument("--profile-name", "-p", default="system")
    main_parser.add_argument("--specialisation", "-c")
    main_parser.add_argument("--rollback", action="store_true")
    main_parser.add_argument("--upgrade", action="store_true")
    main_parser.add_argument("--upgrade-all", action="store_true")
    main_parser.add_argument("--json", action="store_true")
    main_parser.add_argument("--sudo", action="store_true")
    main_parser.add_argument("--ask-sudo-password", action="store_true")
    main_parser.add_argument("--use-remote-sudo", action="store_true")  # deprecated
    main_parser.add_argument("--no-ssh-tty", action="store_true")  # deprecated
    # parser.add_argument("--build-host")  # TODO
    main_parser.add_argument("--target-host")
    main_parser.add_argument("action", choices=Action.values(), nargs="?")

    return main_parser, sub_parsers


def parse_args(
    argv: list[str],
) -> tuple[argparse.Namespace, dict[str, argparse.Namespace]]:
    parser, sub_parsers = get_parser()
    args = parser.parse_args(argv[1:])
    args_groups = {
        group: parser.parse_known_args(argv[1:])[0]
        for group, parser in sub_parsers.items()
    }

    def parser_warn(msg: str) -> None:
        info(f"{parser.prog}: warning: {msg}")

    global VERBOSE
    # This flag affects both nix and this script
    VERBOSE = args.verbose

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L56
    if args.action == Action.DRY_RUN.value:
        args.action = Action.DRY_BUILD.value

    if args.ask_sudo_password:
        args.sudo = True

    # TODO: use deprecated=True in Python >=3.13
    if args.install_grub:
        parser_warn("--install-grub deprecated, use --install-bootloader instead")
        args.install_bootloader = True

    # TODO: use deprecated=True in Python >=3.13
    if args.use_remote_sudo:
        parser_warn("--use-remote-sudo deprecated, use --sudo instead")
        args.sudo = True

    # TODO: use deprecated=True in Python >=3.13
    if args.no_ssh_tty:
        parser_warn("--no-ssh-tty deprecated, SSH's TTY is never used anymore")

    if args.action == Action.EDIT.value and (args.file or args.attr):
        parser.error("--file and --attr are not supported with 'edit'")

    if args.target_host and args.action not in (
        Action.SWITCH.value,
        Action.BOOT.value,
        Action.TEST.value,
        Action.BUILD.value,
        Action.DRY_BUILD.value,
        Action.DRY_ACTIVATE.value,
    ):
        parser.error(f"--target-host is not supported with '{args.action}'")

    if args.flake and (args.file or args.attr):
        parser.error("--flake cannot be used with --file or --attr")

    if args.help or args.action is None:
        r = run(["man", "8", "nixos-rebuild"], check=False)
        parser.exit(r.returncode)

    return args, args_groups


def execute(argv: list[str]) -> None:
    args, args_groups = parse_args(argv)

    common_flags = vars(args_groups["common_flags"])
    common_build_flags = common_flags | vars(args_groups["common_build_flags"])
    build_flags = common_build_flags | vars(args_groups["classic_build_flags"])
    flake_build_flags = common_build_flags | vars(args_groups["flake_build_flags"])
    copy_flags = common_flags | vars(args_groups["copy_flags"])

    # Will be cleaned up on exit automatically.
    tmpdir = TemporaryDirectory(prefix="nixos-rebuild.")
    tmpdir_path = Path(tmpdir.name)
    atexit.register(cleanup_ssh, tmpdir_path)

    profile = Profile.from_name(args.profile_name)
    target_host = Remote.from_arg(args.target_host, args.ask_sudo_password, tmpdir_path)
    flake = Flake.from_arg(args.flake, target_host)

    if args.upgrade or args.upgrade_all:
        nix.upgrade_channels(bool(args.upgrade_all))

    action = Action(args.action)
    # Only run shell scripts from the Nixpkgs tree if the action is
    # "switch", "boot", or "test". With other actions (such as "build"),
    # the user may reasonably expect that no code from the Nixpkgs tree is
    # executed, so it's safe to run nixos-rebuild against a potentially
    # untrusted tree.
    can_run = action in (Action.SWITCH, Action.BOOT, Action.TEST)
    if can_run and not flake:
        nixpkgs_path = nix.find_file("nixpkgs", **build_flags)
        rev = nix.get_nixpkgs_rev(nixpkgs_path)
        if nixpkgs_path and rev:
            (nixpkgs_path / ".version-suffix").write_text(rev)

    match action:
        case Action.SWITCH | Action.BOOT:
            info("building the system configuration...")
            if args.rollback:
                path_to_config = nix.rollback(profile, target_host, sudo=args.sudo)
            else:
                if flake:
                    path_to_config = nix.nixos_build_flake(
                        "toplevel",
                        flake,
                        no_link=True,
                        **flake_build_flags,
                    )
                else:
                    path_to_config = nix.nixos_build(
                        "system",
                        args.attr,
                        args.file,
                        no_out_link=True,
                        **build_flags,
                    )
                nix.copy_closure(path_to_config, target_host, **copy_flags)
                nix.set_profile(profile, path_to_config, target_host, sudo=args.sudo)
            nix.switch_to_configuration(
                path_to_config,
                action,
                target_host,
                sudo=args.sudo,
                specialisation=args.specialisation,
                install_bootloader=args.install_bootloader,
            )
        case Action.TEST | Action.BUILD | Action.DRY_BUILD | Action.DRY_ACTIVATE:
            info("building the system configuration...")
            dry_run = action == Action.DRY_BUILD
            if args.rollback:
                if action not in (Action.TEST, Action.BUILD):
                    raise NRError(f"--rollback is incompatible with '{action}'")
                maybe_path_to_config = nix.rollback_temporary_profile(
                    profile,
                    target_host,
                    sudo=args.sudo,
                )
                if maybe_path_to_config:  # kinda silly but this makes mypy happy
                    path_to_config = maybe_path_to_config
                else:
                    raise NRError("could not find previous generation")
            elif flake:
                path_to_config = nix.nixos_build_flake(
                    "toplevel",
                    flake,
                    dry_run=dry_run,
                    **flake_build_flags,
                )
            else:
                path_to_config = nix.nixos_build(
                    "system",
                    args.attr,
                    args.file,
                    dry_run=dry_run,
                    **build_flags,
                )
            if action in (Action.TEST, Action.DRY_ACTIVATE):
                nix.switch_to_configuration(
                    path_to_config,
                    action,
                    target_host,
                    sudo=args.sudo,
                    specialisation=args.specialisation,
                )
        case Action.BUILD_VM | Action.BUILD_VM_WITH_BOOTLOADER:
            info("building the system configuration...")
            attr = "vm" if action == Action.BUILD_VM else "vmWithBootLoader"
            if flake:
                path_to_config = nix.nixos_build_flake(
                    attr,
                    flake,
                    **flake_build_flags,
                )
            else:
                path_to_config = nix.nixos_build(
                    attr,
                    args.attr,
                    args.file,
                    **build_flags,
                )
            vm_path = next(path_to_config.glob("bin/run-*-vm"), "./result/bin/run-*-vm")
            print(f"Done. The virtual machine can be started by running '{vm_path}'")
        case Action.EDIT:
            nix.edit(flake, **flake_build_flags)
        case Action.DRY_RUN:
            assert False, "DRY_RUN should be a DRY_BUILD alias"
        case Action.LIST_GENERATIONS:
            generations = nix.list_generations(profile)
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
