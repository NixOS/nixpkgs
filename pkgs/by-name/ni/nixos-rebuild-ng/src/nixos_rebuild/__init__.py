import argparse
import logging
import sys
from subprocess import CalledProcessError, run
from typing import Final, assert_never

from . import nix, services
from .constants import EXECUTABLE, WITH_REEXEC, WITH_SHELL_FILES
from .models import Action, BuildAttr, Flake, Profile
from .process import Remote
from .utils import LogFormatter

logger: Final = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def get_parser() -> tuple[argparse.ArgumentParser, dict[str, argparse.ArgumentParser]]:
    common_flags = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    common_flags.add_argument(
        "--verbose",
        "-v",
        action="count",
        dest="v",
        default=0,
        help="Enable verbose logging (includes nix)",
    )
    common_flags.add_argument("--quiet", action="count", default=0)
    common_flags.add_argument("--max-jobs", "-j")
    common_flags.add_argument("--cores")
    common_flags.add_argument("--log-format")
    common_flags.add_argument("--keep-going", "-k", action="store_true")
    common_flags.add_argument("--keep-failed", "-K", action="store_true")
    common_flags.add_argument("--fallback", action="store_true")
    common_flags.add_argument("--repair", action="store_true")
    common_flags.add_argument("--option", nargs=2, action="append")

    common_build_flags = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    common_build_flags.add_argument("--builders")
    common_build_flags.add_argument("--include", "-I", action="append")
    common_build_flags.add_argument("--print-build-logs", "-L", action="store_true")
    common_build_flags.add_argument("--show-trace", action="store_true")

    flake_common_flags = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
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
    flake_common_flags.add_argument("--update-input", action="append")
    flake_common_flags.add_argument("--override-input", nargs=2, action="append")

    classic_build_flags = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    classic_build_flags.add_argument("--no-build-output", "-Q", action="store_true")

    copy_flags = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
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
        "specified attribute path from file specified by the --file option",
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
        "by the relevant configuration options",
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
        "the system and channels which have a file named '.update-on-nixos-rebuild'",
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
        "--no-reexec",
        action="store_true",
        help="Do not update nixos-rebuild in-place (also known as re-exec) before build",
    )
    main_parser.add_argument(
        "--fast",
        action="store_true",
        help="Deprecated, use '--no-reexec' instead",
    )
    main_parser.add_argument("--build-host", help="Specifies host to perform the build")
    main_parser.add_argument(
        "--target-host", help="Specifies host to activate the configuration"
    )
    main_parser.add_argument("--no-build-nix", action="store_true", help="Deprecated")
    main_parser.add_argument(
        "--image-variant",
        help="Selects an image variant to build from the "
        "config.system.build.images attribute of the given configuration",
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

    if args.install_grub:
        parser_warn("--install-grub is deprecated, use --install-bootloader instead")
        args.install_bootloader = True

    if args.use_remote_sudo:
        parser_warn("--use-remote-sudo is deprecated, use --sudo instead")
        args.sudo = True

    if args.fast:
        parser_warn("--fast is deprecated, use --no-reexec instead")
        args.no_reexec = True

    if args.no_ssh_tty:
        parser_warn("--no-ssh-tty is deprecated, SSH's TTY is never used anymore")

    if args.no_build_nix:
        parser_warn("--no-build-nix is deprecated, we do not build nix anymore")

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


def execute(argv: list[str]) -> None:
    args, args_groups = parse_args(argv)

    common_flags = vars(args_groups["common_flags"])
    common_build_flags = common_flags | vars(args_groups["common_build_flags"])
    build_flags = common_build_flags | vars(args_groups["classic_build_flags"])
    flake_common_flags = common_flags | vars(args_groups["flake_common_flags"])
    flake_build_flags = common_build_flags | flake_common_flags
    copy_flags = common_flags | vars(args_groups["copy_flags"])

    if args.upgrade or args.upgrade_all:
        nix.upgrade_channels(args.upgrade_all, args.sudo)

    action = Action(args.action)
    # Only run shell scripts from the Nixpkgs tree if the action is
    # "switch", "boot", or "test". With other actions (such as "build"),
    # the user may reasonably expect that no code from the Nixpkgs tree is
    # executed, so it's safe to run nixos-rebuild against a potentially
    # untrusted tree.
    can_run = action in (Action.SWITCH, Action.BOOT, Action.TEST)

    # Re-exec to a newer version of the script before building to ensure we get
    # the latest fixes
    if WITH_REEXEC and can_run and not args.no_reexec:
        services.reexec(argv, args, build_flags, flake_build_flags)

    profile = Profile.from_arg(args.profile_name)
    target_host = Remote.from_arg(args.target_host, args.ask_sudo_password)
    build_host = Remote.from_arg(args.build_host, False, validate_opts=False)
    build_attr = BuildAttr.from_arg(args.attr, args.file)
    flake = Flake.from_arg(args.flake, target_host)

    if can_run and not flake:
        services.write_version_suffix(build_flags)

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
            services.build_and_activate_system(
                action=action,
                args=args,
                build_host=build_host,
                target_host=target_host,
                profile=profile,
                flake=flake,
                build_attr=build_attr,
                build_flags=build_flags,
                common_flags=common_flags,
                copy_flags=copy_flags,
                flake_build_flags=flake_build_flags,
                flake_common_flags=flake_common_flags,
            )

        case Action.EDIT:
            services.edit(flake=flake, flake_build_flags=flake_build_flags)

        case Action.DRY_RUN:
            raise AssertionError("DRY_RUN should be a DRY_BUILD alias")

        case Action.LIST_GENERATIONS:
            services.list_generations(args=args, profile=profile)

        case Action.REPL:
            services.repl(
                flake=flake,
                build_attr=build_attr,
                flake_build_flags=flake_build_flags,
                build_flags=build_flags,
            )

        case _:
            assert_never(action)


def main() -> None:
    ch = logging.StreamHandler()
    ch.setFormatter(LogFormatter())
    logger.addHandler(ch)

    try:
        execute(sys.argv)
    except CalledProcessError as ex:
        _handle_called_process_error(ex)
    except (Exception, KeyboardInterrupt) as ex:
        if logger.isEnabledFor(logging.DEBUG):
            raise
        else:
            sys.exit(str(ex))


def _handle_called_process_error(ex: CalledProcessError) -> None:
    if logger.isEnabledFor(logging.DEBUG):
        import traceback

        traceback.print_exception(ex)
    else:
        import shlex

        # If cmd is a list, stringify any Paths and join in a single string
        # This will show much nicer in the error (e.g., as something that
        # the user can simple copy-paste in terminal to debug)
        cmd = (
            shlex.join([str(cmd) for cmd in ex.cmd])
            if isinstance(ex.cmd, list)
            else ex.cmd
        )
        ex = CalledProcessError(
            returncode=ex.returncode,
            cmd=cmd,
            output=ex.output,
            stderr=ex.stderr,
        )
        print(str(ex), file=sys.stderr)

    # Exit with the error code of the process that failed
    sys.exit(ex.returncode)
