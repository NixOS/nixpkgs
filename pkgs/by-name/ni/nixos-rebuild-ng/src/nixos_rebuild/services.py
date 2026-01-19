import argparse
import json
import logging
import os
import sys
from pathlib import Path
from typing import Final

from . import nix, tmpdir
from .constants import EXECUTABLE
from .models import (
    Action,
    BuildAttr,
    Flake,
    GroupedNixArgs,
    ImageVariants,
    NixOSRebuildError,
    Profile,
)
from .process import Remote, cleanup_ssh
from .utils import tabulate

NIXOS_REBUILD_ATTR: Final = "config.system.build.nixos-rebuild"
NIXOS_REBUILD_REEXEC_ENV: Final = "_NIXOS_REBUILD_REEXEC"

logger: Final = logging.getLogger(__name__)


def reexec(
    argv: list[str],
    args: argparse.Namespace,
    grouped_nix_args: GroupedNixArgs,
) -> None:
    if os.environ.get(NIXOS_REBUILD_REEXEC_ENV):
        return

    drv = None
    # Parsing the args here but ignore ask_sudo_password since it is not
    # needed and we would end up asking sudo password twice
    if flake := Flake.from_arg(
        args.flake, Remote.from_arg(args.target_host, ask_sudo_password=None)
    ):
        drv = nix.build_flake(
            NIXOS_REBUILD_ATTR,
            flake,
            grouped_nix_args.flake_build_flags | {"no_link": True},
        )
    else:
        build_attr = BuildAttr.from_arg(args.attr, args.file)
        drv = nix.build(
            NIXOS_REBUILD_ATTR,
            build_attr,
            grouped_nix_args.build_flags | {"no_out_link": True},
        )

    if drv:
        new = drv / f"bin/{EXECUTABLE}"
        current = Path(argv[0])
        if new != current:
            logger.debug(
                "detected newer version of script, re-exec'ing, current=%s, new=%s",
                current,
                new,
            )
            # Manually call clean-up functions since os.execve() will replace
            # the process immediately
            cleanup_ssh()
            tmpdir.TMPDIR.cleanup()
            try:
                os.execve(new, argv, os.environ | {NIXOS_REBUILD_REEXEC_ENV: "1"})
            except Exception:
                # Possible errors that we can have here:
                # - Missing the binary
                # - Exec format error (e.g.: another OS/CPU arch)
                logger.warning(
                    "could not re-exec in a newer version of nixos-rebuild, "
                    "using current version",
                    exc_info=logger.isEnabledFor(logging.DEBUG),
                )
                # We already run clean-up, let's re-exec in the current version
                # to avoid issues
                os.execve(current, argv, os.environ | {NIXOS_REBUILD_REEXEC_ENV: "1"})


def _validate_image_variant(image_variant: str, variants: ImageVariants) -> None:
    if image_variant not in variants:
        raise NixOSRebuildError(
            "please specify one of the following supported image variants via "
            "--image-variant:\n" + "\n".join(f"- {v}" for v in variants)
        )


def _get_system_attr(
    action: Action,
    args: argparse.Namespace,
    flake: Flake | None,
    build_attr: BuildAttr,
    grouped_nix_args: GroupedNixArgs,
) -> str:
    match action:
        case Action.BUILD_IMAGE if flake:
            variants = nix.get_build_image_variants_flake(
                flake,
                eval_flags=grouped_nix_args.flake_common_flags,
            )
            _validate_image_variant(args.image_variant, variants)
            attr = f"config.system.build.images.{args.image_variant}"
        case Action.BUILD_IMAGE:
            variants = nix.get_build_image_variants(
                build_attr,
                instantiate_flags=grouped_nix_args.common_flags,
            )
            _validate_image_variant(args.image_variant, variants)
            attr = f"config.system.build.images.{args.image_variant}"
        case Action.BUILD_VM:
            attr = "config.system.build.vm"
        case Action.BUILD_VM_WITH_BOOTLOADER:
            attr = "config.system.build.vmWithBootLoader"
        case _:
            attr = "config.system.build.toplevel"

    return attr


def _rollback_system(
    action: Action,
    args: argparse.Namespace,
    target_host: Remote | None,
    profile: Profile,
) -> Path:
    match action:
        case Action.SWITCH | Action.BOOT:
            path_to_config = nix.rollback(profile, target_host, sudo=args.sudo)
        case Action.TEST | Action.BUILD:
            maybe_path_to_config = nix.rollback_temporary_profile(
                profile,
                target_host,
                sudo=args.sudo,
            )
            if maybe_path_to_config:
                path_to_config = maybe_path_to_config
            else:
                raise NixOSRebuildError("could not find previous generation")

    return path_to_config


def _build_system(
    attr: str,
    action: Action,
    build_host: Remote | None,
    target_host: Remote | None,
    flake: Flake | None,
    build_attr: BuildAttr,
    grouped_nix_args: GroupedNixArgs,
) -> Path:
    dry_run = action == Action.DRY_BUILD
    # actions that we will not add a /result symlink in CWD
    no_link = action in (Action.SWITCH, Action.BOOT, Action.TEST, Action.DRY_ACTIVATE)

    match (build_host, flake):
        case (Remote(_), Flake(_)):
            path_to_config = nix.build_remote_flake(
                attr,
                flake,
                build_host,
                eval_flags=grouped_nix_args.flake_common_flags,
                flake_build_flags={"no_link": no_link, "dry_run": dry_run}
                | grouped_nix_args.flake_build_flags,
                copy_flags=grouped_nix_args.copy_flags,
            )
        case (None, Flake(_)):
            path_to_config = nix.build_flake(
                attr,
                flake,
                flake_build_flags={"no_link": no_link, "dry_run": dry_run}
                | grouped_nix_args.flake_build_flags,
            )
        case (Remote(_), None):
            path_to_config = nix.build_remote(
                attr,
                build_attr,
                build_host,
                realise_flags=grouped_nix_args.common_flags,
                instantiate_flags=grouped_nix_args.build_flags,
                copy_flags=grouped_nix_args.copy_flags,
            )
        case (None, None):
            path_to_config = nix.build(
                attr,
                build_attr,
                build_flags={"no_out_link": no_link, "dry_run": dry_run}
                | grouped_nix_args.build_flags,
            )

    # In dry_run mode there is nothing to copy
    # https://github.com/NixOS/nixpkgs/issues/444156
    if not dry_run:
        nix.copy_closure(
            path_to_config,
            to_host=target_host,
            from_host=build_host,
            copy_flags=grouped_nix_args.copy_flags,
        )

    return path_to_config


def _activate_system(
    path_to_config: Path,
    action: Action,
    args: argparse.Namespace,
    target_host: Remote | None,
    profile: Profile,
    flake: Flake | None,
    build_attr: BuildAttr,
    grouped_nix_args: GroupedNixArgs,
) -> None:
    # Print only the result to stdout to make it easier to script
    def print_result(msg: str, result: str | Path) -> None:
        print(msg, end=" ", file=sys.stderr, flush=True)
        print(result, flush=True)

    match action:
        case Action.SWITCH | Action.BOOT if not args.rollback:
            nix.set_profile(
                profile,
                path_to_config,
                target_host=target_host,
                sudo=args.sudo,
            )
            nix.switch_to_configuration(
                path_to_config,
                action,
                target_host=target_host,
                sudo=args.sudo,
                specialisation=args.specialisation,
                install_bootloader=args.install_bootloader,
            )
            print_result("Done. The new configuration is", path_to_config)
        case Action.SWITCH | Action.BOOT | Action.TEST | Action.DRY_ACTIVATE:
            nix.switch_to_configuration(
                path_to_config,
                action,
                target_host=target_host,
                sudo=args.sudo,
                specialisation=args.specialisation,
                install_bootloader=args.install_bootloader,
            )
            print_result("Done. The new configuration is", path_to_config)
        case Action.BUILD:
            print_result("Done. The new configuration is", path_to_config)
        case Action.BUILD_VM | Action.BUILD_VM_WITH_BOOTLOADER:
            # If you get `not-found`, please open an issue
            vm_path = next(path_to_config.glob("bin/run-*-vm"), "not-found")
            print_result("Done. The virtual machine can be started by running", vm_path)
        case Action.BUILD_IMAGE:
            if flake:
                image_name = nix.get_build_image_name_flake(
                    flake,
                    args.image_variant,
                    eval_flags=grouped_nix_args.flake_common_flags,
                )
            else:
                image_name = nix.get_build_image_name(
                    build_attr,
                    args.image_variant,
                    instantiate_flags=grouped_nix_args.common_flags,
                )
            disk_path = path_to_config / image_name
            print_result("Done. The disk image can be found in", disk_path)


def build_and_activate_system(
    action: Action,
    args: argparse.Namespace,
    build_host: Remote | None,
    target_host: Remote | None,
    profile: Profile,
    flake: Flake | None,
    build_attr: BuildAttr,
    grouped_nix_args: GroupedNixArgs,
) -> None:
    logger.info("building the system configuration...")
    attr = _get_system_attr(
        action=action,
        args=args,
        flake=flake,
        build_attr=build_attr,
        grouped_nix_args=grouped_nix_args,
    )

    if args.rollback:
        path_to_config = _rollback_system(
            action=action,
            args=args,
            target_host=target_host,
            profile=profile,
        )
    else:
        path_to_config = _build_system(
            attr=attr,
            action=action,
            build_host=build_host,
            target_host=target_host,
            flake=flake,
            build_attr=build_attr,
            grouped_nix_args=grouped_nix_args,
        )

    _activate_system(
        path_to_config=path_to_config,
        action=action,
        args=args,
        target_host=target_host,
        profile=profile,
        flake=flake,
        build_attr=build_attr,
        grouped_nix_args=grouped_nix_args,
    )


def edit(flake: Flake | None, grouped_nix_args: GroupedNixArgs) -> None:
    if flake:
        nix.edit_flake(flake, grouped_nix_args.flake_build_flags)
    else:
        nix.edit()


def list_generations(
    args: argparse.Namespace,
    profile: Profile,
) -> None:
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


def repl(
    flake: Flake | None,
    build_attr: BuildAttr,
    grouped_nix_args: GroupedNixArgs,
) -> None:
    if flake:
        nix.repl_flake(flake, grouped_nix_args.flake_build_flags)
    else:
        nix.repl(build_attr, grouped_nix_args.build_flags)


def write_version_suffix(grouped_nix_args: GroupedNixArgs) -> None:
    nixpkgs_path = nix.find_file("nixpkgs", grouped_nix_args.build_flags)
    rev = nix.get_nixpkgs_rev(nixpkgs_path)
    if nixpkgs_path and rev:
        try:
            (nixpkgs_path / ".version-suffix").write_text(rev)
        except OSError as error:
            logger.debug(
                "ignoring error while writing '.version-suffix' to nixpkgs: %s",
                error,
            )
