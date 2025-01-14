import argparse
import json
import logging
import os
import sys
from pathlib import Path
from subprocess import CalledProcessError, run
from typing import assert_never

from . import nix, tmpdir
from .constants import EXECUTABLE, WITH_NIX_2_18, WITH_REEXEC, WITH_SHELL_FILES
from .models import Action, BuildAttr, Flake, ImageVariants, NRError, Profile
from .process import Remote, cleanup_ssh
from .utils import Args, LogFormatter, tabulate

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_parser() -> tuple[argparse.ArgumentParser, dict[str, argparse.ArgumentParser]]:
    common_flags = argparse.ArgumentParser(add_help=False)
    common_flags.add_argument(
        "--verbose",
        "-v",
        action="count",
        dest="v",
        default=0,
        help="Enable verbose logging (includes nix)",
    )
    common_flags.add_argument("--max-jobs", "-j")
    common_flags.add_argument("--cores")
    common_flags.add_argument("--log-format")
    common_flags.add_argument("--keep-going", "-k", action="store_true")
    common_flags.add_argument("--keep-failed", "-K", action="store_true")
    common_flags.add_argument("--fallback", action="store_true")
    common_flags.add_argument("--repair", action="store_true")
    common_flags.add_argument("--option", nargs=2)

    common_build_flags = argparse.ArgumentParser(add_help=False)
    common_build_flags.add_argument("--builders")
    common_build_flags.add_argument("--include", "-I", action="append")
    common_build_flags.add_argument("--quiet", action="store_true")
    common_build_flags.add_argument("--print-build-logs", "-L", action="store_true")
    common_build_flags.add_argument("--show-trace", action="store_true")

    flake_common_flags = argparse.ArgumentParser(add_help=False)
    flake_common_flags.add_argument("--accept-flake-config", action="store_true")
    flake_common_flags.add_argument("--refresh", action="store_true")
    flake_common_flags.add_argument("--impure", action="store_true")
    flake_common_flags.add_argument("--offline", action="store_true")
    flake_common_flags.add_argument("--no-net", action="store_true")
    flake_common_flags.add_argument("--recreate-lock-file", action="store_true")
    flake_common_flags.add_argument("--no-update-lock-file", action="store_true")
    flake_common_flags.add_argument("--no-write-lock-file", action="store_true")
    flake_common_flags.add_argument("--no-registries", action="store_true")
    flake_common_flags.add_argument("--commit-lock-file", action="store_true")
    flake_common_flags.add_argument("--update-input")
    flake_common_flags.add_argument("--override-input", nargs=2)

    classic_build_flags = argparse.ArgumentParser(add_help=False)
    classic_build_flags.add_argument("--no-build-output", "-Q", action="store_true")

    copy_flags = argparse.ArgumentParser(add_help=False)
    copy_flags.add_argument(
        "--use-substitutes",
        "--substitute-on-destination",
        "-s",
        action="store_true",
        # `-s` is the destination since it has the same meaning in
        # `nix-copy-closure` and `nix copy`
        dest="s",
    )

    sub_parsers = {
        "common_flags": common_flags,
        "common_build_flags": common_build_flags,
        "flake_common_flags": flake_common_flags,
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
    main_parser.add_argument("--help", "-h", action="store_true", help="Show manpage")
    main_parser.add_argument(
        "--debug", action="store_true", help="Enable debug logging"
    )
    main_parser.add_argument(
        "--file", "-f", help="Enable and build the NixOS system from the specified file"
    )
    main_parser.add_argument(
        "--attr",
        "-A",
        help="Enable and build the NixOS system from nix file and use the "
        + "specified attribute path from file specified by the --file option",
    )
    main_parser.add_argument(
        "--flake",
        nargs="?",
        const=True,
        help="Build the NixOS system from the specified flake",
    )
    main_parser.add_argument(
        "--no-flake",
        dest="flake",
        action="store_false",
        help="Do not imply --flake if /etc/nixos/flake.nix exists",
    )
    main_parser.add_argument(
        "--install-bootloader",
        action="store_true",
        help="Causes the boot loader to be (re)installed on the device specified "
        + "by the relevant configuration options",
    )
    main_parser.add_argument(
        "--install-grub",
        action="store_true",
        help="Deprecated, use '--install-bootloader' instead",
    )
    main_parser.add_argument(
        "--profile-name",
        "-p",
        default="system",
        help="Use nix profile /nix/var/nix/profiles/system-profiles/<profile-name>",
    )
    main_parser.add_argument(
        "--specialisation", "-c", help="Activates given specialisation"
    )
    main_parser.add_argument(
        "--rollback",
        action="store_true",
        help="Roll back to the previous configuration",
    )
    main_parser.add_argument(
        "--upgrade",
        action="store_true",
        help="Update the root user's channel named 'nixos' before rebuilding "
        + "the system and channels which have a file named '.update-on-nixos-rebuild'",
    )
    main_parser.add_argument(
        "--upgrade-all",
        action="store_true",
        help="Same as --upgrade, but updates all root user's channels",
    )
    main_parser.add_argument(
        "--json",
        action="store_true",
        help="JSON output, only implemented for 'list-generations' right now",
    )
    main_parser.add_argument(
        "--ask-sudo-password",
        action="store_true",
        help="Asks for sudo password for remote activation, implies --sudo",
    )
    main_parser.add_argument(
        "--sudo", action="store_true", help="Prefixes activation commands with sudo"
    )
    main_parser.add_argument(
        "--use-remote-sudo",
        action="store_true",
        help="Deprecated, use '--sudo' instead",
    )
    main_parser.add_argument("--no-ssh-tty", action="store_true", help="Deprecated")
    main_parser.add_argument(
        "--fast",
        action="store_true",
        help="Skip possibly expensive operations",
    )
    main_parser.add_argument("--build-host", help="Specifies host to perform the build")
    main_parser.add_argument(
        "--target-host", help="Specifies host to activate the configuration"
    )
    main_parser.add_argument("--no-build-nix", action="store_true", help="Deprecated")
    main_parser.add_argument(
        "--image-variant",
        help="Selects an image variant to build from the "
        + "config.system.build.images attribute of the given configuration",
    )
    main_parser.add_argument("action", choices=Action.values(), nargs="?")

    return main_parser, sub_parsers


# For shtab to generate completions
def get_main_parser() -> argparse.ArgumentParser:
    return get_parser()[0]


def parse_args(
    argv: list[str],
) -> tuple[argparse.Namespace, dict[str, argparse.Namespace]]:
    parser, sub_parsers = get_parser()
    args = parser.parse_args(argv[1:])
    args_groups = {
        group: parser.parse_known_args(argv[1:])[0]
        for group, parser in sub_parsers.items()
    }

    if args.help or args.action is None:
        if WITH_SHELL_FILES:
            r = run(["man", "8", EXECUTABLE], check=False)
            parser.exit(r.returncode)
        else:
            parser.print_help()
            parser.exit()

    def parser_warn(msg: str) -> None:
        print(f"{parser.prog}: warning: {msg}", file=sys.stderr)

    # verbose affects both nix commands and this script, debug only this script
    if args.v or args.debug:
        logger.setLevel(logging.DEBUG)

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
        Action.BUILD_VM.value,
        Action.BUILD_VM_WITH_BOOTLOADER.value,
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
    build_flags: Args,
    flake_build_flags: Args,
) -> None:
    drv = None
    attr = "config.system.build.nixos-rebuild"
    try:
        # Parsing the args here but ignore ask_sudo_password since it is not
        # needed and we would end up asking sudo password twice
        if flake := Flake.from_arg(args.flake, Remote.from_arg(args.target_host, None)):
            drv = nix.build_flake(
                attr,
                flake,
                flake_build_flags | {"no_link": True},
            )
        else:
            build_attr = BuildAttr.from_arg(args.attr, args.file)
            drv = nix.build(
                attr,
                build_attr,
                build_flags | {"no_out_link": True},
            )
    except CalledProcessError:
        logger.warning(
            "could not build a newer version of nixos-rebuild, using current version"
        )

    if drv:
        new = drv / f"bin/{EXECUTABLE}"
        current = Path(argv[0])
        if new != current:
            logging.debug(
                "detected newer version of script, re-exec'ing, current=%s, new=%s",
                current,
                new,
            )
            # Manually call clean-up functions since os.execve() will replace
            # the process immediately
            cleanup_ssh()
            tmpdir.TMPDIR.cleanup()
            try:
                os.execve(new, argv, os.environ | {"_NIXOS_REBUILD_REEXEC": "1"})
            except Exception:
                # Possible errors that we can have here:
                # - Missing the binary
                # - Exec format error (e.g.: another OS/CPU arch)
                logger.warning(
                    "could not re-exec in a newer version of nixos-rebuild, "
                    + "using current version"
                )
                logger.debug("re-exec exception", exc_info=True)
                # We already run clean-up, let's re-exec in the current version
                # to avoid issues
                os.execve(current, argv, os.environ | {"_NIXOS_REBUILD_REEXEC": "1"})


def execute(argv: list[str]) -> None:
    args, args_groups = parse_args(argv)

    if not WITH_NIX_2_18:
        logger.warning("you're using Nix <2.18, some features will not work correctly")

    common_flags = vars(args_groups["common_flags"])
    common_build_flags = common_flags | vars(args_groups["common_build_flags"])
    build_flags = common_build_flags | vars(args_groups["classic_build_flags"])
    flake_common_flags = common_flags | vars(args_groups["flake_common_flags"])
    flake_build_flags = common_build_flags | flake_common_flags
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
        WITH_REEXEC
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
        nixpkgs_path = nix.find_file("nixpkgs", build_flags)
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
            | Action.BUILD_IMAGE
            | Action.BUILD_VM
            | Action.BUILD_VM_WITH_BOOTLOADER
        ):
            logger.info("building the system configuration...")

            dry_run = action == Action.DRY_BUILD
            no_link = action in (Action.SWITCH, Action.BOOT)
            build_flags |= {"no_out_link": no_link, "dry_run": dry_run}
            flake_build_flags |= {"no_link": no_link, "dry_run": dry_run}
            rollback = bool(args.rollback)

            def validate_image_variant(variants: ImageVariants) -> None:
                if args.image_variant not in variants:
                    raise NRError(
                        "please specify one of the following "
                        + "supported image variants via --image-variant:\n"
                        + "\n".join(f"- {v}" for v in variants.keys())
                    )

            match action:
                case Action.BUILD_IMAGE if flake:
                    variants = nix.get_build_image_variants_flake(
                        flake,
                        eval_flags=flake_common_flags,
                    )
                    validate_image_variant(variants)
                    attr = f"config.system.build.images.{args.image_variant}"
                case Action.BUILD_IMAGE:
                    variants = nix.get_build_image_variants(
                        build_attr,
                        instantiate_flags=common_flags,
                    )
                    validate_image_variant(variants)
                    attr = f"config.system.build.images.{args.image_variant}"
                case Action.BUILD_VM:
                    attr = "config.system.build.vm"
                case Action.BUILD_VM_WITH_BOOTLOADER:
                    attr = "config.system.build.vmWithBootLoader"
                case _:
                    attr = "config.system.build.toplevel"

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
                    path_to_config = nix.build_remote_flake(
                        attr,
                        flake,
                        build_host,
                        eval_flags=flake_common_flags,
                        flake_build_flags=flake_build_flags,
                        copy_flags=copy_flags,
                    )
                case (_, False, None, Flake(_)):
                    path_to_config = nix.build_flake(
                        attr,
                        flake,
                        flake_build_flags=flake_build_flags,
                    )
                case (_, False, Remote(_), None):
                    path_to_config = nix.build_remote(
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
                        build_flags=build_flags,
                    )
                case never:
                    # should never happen, but mypy is not smart enough to
                    # handle this with assert_never
                    # https://github.com/python/mypy/issues/16650
                    # https://github.com/python/mypy/issues/16722
                    raise AssertionError(
                        f"expected code to be unreachable, but got: {never}"
                    )

            if not rollback:
                nix.copy_closure(
                    path_to_config,
                    to_host=target_host,
                    from_host=build_host,
                    copy_flags=copy_flags,
                )
                if action in (Action.SWITCH, Action.BOOT):
                    nix.set_profile(
                        profile,
                        path_to_config,
                        target_host=target_host,
                        sudo=args.sudo,
                    )

            # Print only the result to stdout to make it easier to script
            def print_result(msg: str, result: str | Path) -> None:
                print(msg, end=" ", file=sys.stderr, flush=True)
                print(result, flush=True)

            match action:
                case Action.SWITCH | Action.BOOT | Action.TEST | Action.DRY_ACTIVATE:
                    nix.switch_to_configuration(
                        path_to_config,
                        action,
                        target_host=target_host,
                        sudo=args.sudo,
                        specialisation=args.specialisation,
                        install_bootloader=args.install_bootloader,
                    )
                case Action.BUILD_VM | Action.BUILD_VM_WITH_BOOTLOADER:
                    # If you get `not-found`, please open an issue
                    vm_path = next(path_to_config.glob("bin/run-*-vm"), "not-found")
                    print_result(
                        "Done. The virtual machine can be started by running", vm_path
                    )
                case Action.BUILD_IMAGE:
                    disk_path = path_to_config / variants[args.image_variant]
                    print_result("Done. The disk image can be found in", disk_path)

        case Action.EDIT:
            nix.edit(flake, flake_build_flags)

        case Action.DRY_RUN:
            raise AssertionError("DRY_RUN should be a DRY_BUILD alias")

        case Action.LIST_GENERATIONS:
            generations = nix.list_generations(profile)
            if args.json:
                print(json.dumps(generations, indent=2))
            else:
                headers = {
                    "generation": "Generation",
                    "date": "Build-date",
                    "nixosVersion": "NixOS version",
                    "kernelVersion": "Kernel",
                    "configurationRevision": "Configuration Revision",
                    "specialisations": "Specialisation",
                    "current": "Current",
                }
                print(tabulate(generations, headers=headers))

        case Action.REPL:
            if flake:
                nix.repl_flake("toplevel", flake, flake_build_flags)
            else:
                nix.repl("system", build_attr, build_flags)

        case _:
            assert_never(action)


def main() -> None:
    ch = logging.StreamHandler()
    ch.setFormatter(LogFormatter())
    logger.addHandler(ch)

    try:
        execute(sys.argv)
    except CalledProcessError as ex:
        if logger.level == logging.DEBUG:
            import traceback

            traceback.print_exc()
        else:
            print(str(ex), file=sys.stderr)
        # Exit with the error code of the process that failed
        sys.exit(ex.returncode)
    except (Exception, KeyboardInterrupt) as ex:
        if logger.level == logging.DEBUG:
            raise
        else:
            sys.exit(str(ex))
