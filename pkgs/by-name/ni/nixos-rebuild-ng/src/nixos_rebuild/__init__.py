import argparse
import atexit
import json
import logging
import os
import sys
from pathlib import Path
from subprocess import CalledProcessError, run
from typing import assert_never

from . import nix
from .models import Action, BuildAttr, Flake, NRError, Profile
from .process import Remote, cleanup_ssh
from .utils import Args, LogFormatter

logger = logging.getLogger()
logger.setLevel(logging.INFO)


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
    copy_flags.add_argument(
        "--use-substitutes", "--substitute-on-destination", "-s", action="store_true"
    )

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
    main_parser.add_argument("--fast", action="store_true")
    main_parser.add_argument("--build-host")
    main_parser.add_argument("--target-host")
    main_parser.add_argument("--no-build-nix", action="store_true")  # deprecated
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
        print(f"{parser.prog}: warning: {msg}", file=sys.stderr)

    # This flag affects both nix and this script
    if args.verbose:
        logger.setLevel(logging.DEBUG)

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L56
    if args.action == Action.DRY_RUN.value:
        args.action = Action.DRY_BUILD.value

    if args.ask_sudo_password:
        args.sudo = True

    if args.help or args.action is None:
        r = run(["man", "8", "nixos-rebuild"], check=False)
        parser.exit(r.returncode)

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

    # TODO: use deprecated=True in Python >=3.13
    if args.no_build_nix:
        parser_warn("--no-build-nix deprecated, we do not build nix anymore")

    if args.action == Action.EDIT.value and (args.file or args.attr):
        parser.error("--file and --attr are not supported with 'edit'")

    if (args.target_host or args.build_host) and args.action not in (
        Action.SWITCH.value,
        Action.BOOT.value,
        Action.TEST.value,
        Action.BUILD.value,
        Action.DRY_BUILD.value,
        Action.DRY_ACTIVATE.value,
    ):
        parser.error(
            f"--target-host/--build-host is not supported with '{args.action}'"
        )

    if args.flake and (args.file or args.attr):
        parser.error("--flake cannot be used with --file or --attr")

    return args, args_groups


def reexec(
    argv: list[str],
    args: argparse.Namespace,
    build_flags: dict[str, Args],
    flake_build_flags: dict[str, Args],
) -> None:
    drv = None
    try:
        # Need to set target_host=None, to avoid connecting to remote
        if flake := Flake.from_arg(args.flake, None):
            drv = nix.build_flake(
                "pkgs.nixos-rebuild-ng",
                flake,
                **flake_build_flags,
                no_link=True,
            )
        else:
            drv = nix.build(
                "pkgs.nixos-rebuild-ng",
                BuildAttr.from_arg(args.attr, args.file),
                **build_flags,
                no_out_link=True,
            )
    except CalledProcessError:
        logger.warning("could not find a newer version of nixos-rebuild")

    if drv:
        new = drv / "bin/nixos-rebuild-ng"
        current = Path(argv[0])
        # Disable re-exec during development
        if current.name != "__main__.py" and new != current:
            logging.debug(
                "detected newer version of script, re-exec'ing, current=%s, new=%s",
                argv[0],
                new,
            )
            cleanup_ssh()
            os.execve(new, argv, os.environ | {"_NIXOS_REBUILD_REEXEC": "1"})


def execute(argv: list[str]) -> None:
    args, args_groups = parse_args(argv)

    atexit.register(cleanup_ssh)

    common_flags = vars(args_groups["common_flags"])
    common_build_flags = common_flags | vars(args_groups["common_build_flags"])
    build_flags = common_build_flags | vars(args_groups["classic_build_flags"])
    flake_build_flags = common_build_flags | vars(args_groups["flake_build_flags"])
    copy_flags = common_flags | vars(args_groups["copy_flags"])

    if args.upgrade or args.upgrade_all:
        nix.upgrade_channels(bool(args.upgrade_all))

    action = Action(args.action)
    # Only run shell scripts from the Nixpkgs tree if the action is
    # "switch", "boot", or "test". With other actions (such as "build"),
    # the user may reasonably expect that no code from the Nixpkgs tree is
    # executed, so it's safe to run nixos-rebuild against a potentially
    # untrusted tree.
    can_run = action in (Action.SWITCH, Action.BOOT, Action.TEST)

    # Re-exec to a newer version of the script before building to ensure we get
    # the latest fixes
    if (
        False  # disabled until we introduce `config.system.build.nixos-rebuild-ng`
        and can_run
        and not args.fast
        and not os.environ.get("_NIXOS_REBUILD_REEXEC")
    ):
        reexec(argv, args, build_flags, flake_build_flags)

    profile = Profile.from_arg(args.profile_name)
    target_host = Remote.from_arg(args.target_host, args.ask_sudo_password)
    build_host = Remote.from_arg(args.build_host, False, validate_opts=False)
    build_attr = BuildAttr.from_arg(args.attr, args.file)
    flake = Flake.from_arg(args.flake, target_host)

    if can_run and not flake:
        nixpkgs_path = nix.find_file("nixpkgs", **build_flags)
        rev = nix.get_nixpkgs_rev(nixpkgs_path)
        if nixpkgs_path and rev:
            (nixpkgs_path / ".version-suffix").write_text(rev)

    match action:
        case (
            Action.SWITCH
            | Action.BOOT
            | Action.TEST
            | Action.BUILD
            | Action.DRY_BUILD
            | Action.DRY_ACTIVATE
        ):
            logger.info("building the system configuration...")

            attr = "config.system.build.toplevel"
            dry_run = action == Action.DRY_BUILD
            no_link = action in (Action.SWITCH, Action.BOOT)
            rollback = bool(args.rollback)

            match (action, rollback, build_host, flake):
                case (Action.SWITCH | Action.BOOT, True, _, _):
                    path_to_config = nix.rollback(profile, target_host, sudo=args.sudo)
                case (Action.TEST | Action.BUILD, True, _, _):
                    maybe_path_to_config = nix.rollback_temporary_profile(
                        profile,
                        target_host,
                        sudo=args.sudo,
                    )
                    if maybe_path_to_config:  # kinda silly but this makes mypy happy
                        path_to_config = maybe_path_to_config
                    else:
                        raise NRError("could not find previous generation")
                case (_, True, _, _):
                    raise NRError(f"--rollback is incompatible with '{action}'")
                case (_, False, Remote(_), Flake(_)):
                    path_to_config = nix.remote_build_flake(
                        attr,
                        flake,
                        build_host,
                        flake_build_flags=flake_build_flags,
                        copy_flags=copy_flags,
                        build_flags=build_flags,
                    )
                case (_, False, None, Flake(_)):
                    path_to_config = nix.build_flake(
                        attr,
                        flake,
                        no_link=no_link,
                        dry_run=dry_run,
                        **flake_build_flags,
                    )
                case (_, False, Remote(_), None):
                    path_to_config = nix.remote_build(
                        attr,
                        build_attr,
                        build_host,
                        instantiate_flags=common_flags,
                        copy_flags=copy_flags,
                        build_flags=build_flags,
                    )
                case (_, False, None, None):
                    path_to_config = nix.build(
                        attr,
                        build_attr,
                        no_out_link=no_link,
                        dry_run=dry_run,
                        **build_flags,
                    )
                case m:
                    # should never happen, but mypy is not smart enough to
                    # handle this with assert_never
                    raise NRError(f"invalid match for build: {m}")

            if not rollback:
                nix.copy_closure(
                    path_to_config,
                    to_host=target_host,
                    from_host=build_host,
                    **copy_flags,
                )
                if action in (Action.SWITCH, Action.BOOT):
                    nix.set_profile(
                        profile,
                        path_to_config,
                        target_host=target_host,
                        sudo=args.sudo,
                    )
            if action in (Action.SWITCH, Action.BOOT, Action.TEST, Action.DRY_ACTIVATE):
                nix.switch_to_configuration(
                    path_to_config,
                    action,
                    target_host=target_host,
                    sudo=args.sudo,
                    specialisation=args.specialisation,
                    install_bootloader=args.install_bootloader,
                )
        case Action.BUILD_VM | Action.BUILD_VM_WITH_BOOTLOADER:
            logger.info("building the system configuration...")
            attr = "vm" if action == Action.BUILD_VM else "vmWithBootLoader"
            if flake:
                path_to_config = nix.build_flake(
                    f"config.system.build.{attr}",
                    flake,
                    **flake_build_flags,
                )
            else:
                path_to_config = nix.build(
                    f"config.system.build.{attr}",
                    build_attr,
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
            if flake:
                nix.repl_flake("toplevel", flake, **flake_build_flags)
            else:
                nix.repl("system", build_attr, **build_flags)
        case _:
            assert_never(action)


def main() -> None:
    ch = logging.StreamHandler()
    ch.setFormatter(LogFormatter())
    logger.addHandler(ch)

    try:
        execute(sys.argv)
    except (Exception, KeyboardInterrupt) as ex:
        if logger.level == logging.DEBUG:
            raise
        else:
            sys.exit(str(ex))
