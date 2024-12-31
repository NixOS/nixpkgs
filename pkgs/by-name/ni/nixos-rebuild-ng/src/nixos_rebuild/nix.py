import logging
import os
from datetime import datetime
from importlib.resources import files
from pathlib import Path
from string import Template
from subprocess import PIPE, CalledProcessError
from typing import Final

from .models import (
    Action,
    BuildAttr,
    Flake,
    Generation,
    GenerationJson,
    NRError,
    Profile,
    Remote,
)
from .process import SSH_DEFAULT_OPTS, run_wrapper
from .utils import Args, dict_to_flags

FLAKE_FLAGS: Final = ["--extra-experimental-features", "nix-command flakes"]
FLAKE_REPL_TEMPLATE: Final = "repl.nix.template"
logger = logging.getLogger(__name__)


def build(
    attr: str,
    build_attr: BuildAttr,
    **build_flags: Args,
) -> Path:
    """Build NixOS attribute using classic Nix.

    Returns the built attribute as path.
    """
    run_args = [
        "nix-build",
        build_attr.path,
        "--attr",
        build_attr.to_attr(attr),
        *dict_to_flags(build_flags),
    ]
    r = run_wrapper(run_args, stdout=PIPE)
    return Path(r.stdout.strip())


def build_flake(
    attr: str,
    flake: Flake,
    **flake_build_flags: Args,
) -> Path:
    """Build NixOS attribute using Flakes.

    Returns the built attribute as path.
    """
    run_args = [
        "nix",
        *FLAKE_FLAGS,
        "build",
        "--print-out-paths",
        flake.to_attr(attr),
        *dict_to_flags(flake_build_flags),
    ]
    r = run_wrapper(run_args, stdout=PIPE)
    return Path(r.stdout.strip())


def remote_build(
    attr: str,
    build_attr: BuildAttr,
    build_host: Remote | None,
    build_flags: dict[str, Args] | None = None,
    instantiate_flags: dict[str, Args] | None = None,
    copy_flags: dict[str, Args] | None = None,
) -> Path:
    r = run_wrapper(
        [
            "nix-instantiate",
            build_attr.path,
            "--attr",
            build_attr.to_attr(attr),
            *dict_to_flags(instantiate_flags or {}),
        ],
        stdout=PIPE,
    )
    drv = Path(r.stdout.strip())
    copy_closure(drv, to_host=build_host, from_host=None, **(copy_flags or {}))
    r = run_wrapper(
        ["nix-store", "--realise", drv, *dict_to_flags(build_flags or {})],
        remote=build_host,
        stdout=PIPE,
    )
    return Path(r.stdout.strip())


def remote_build_flake(
    attr: str,
    flake: Flake,
    build_host: Remote,
    flake_build_flags: dict[str, Args] | None = None,
    copy_flags: dict[str, Args] | None = None,
    build_flags: dict[str, Args] | None = None,
) -> Path:
    r = run_wrapper(
        [
            "nix",
            *FLAKE_FLAGS,
            "eval",
            "--raw",
            flake.to_attr(attr, "drvPath"),
            *dict_to_flags(flake_build_flags or {}),
        ],
        stdout=PIPE,
    )
    drv = Path(r.stdout.strip())
    copy_closure(drv, to_host=build_host, from_host=None, **(copy_flags or {}))
    r = run_wrapper(
        [
            "nix",
            *FLAKE_FLAGS,
            "build",
            f"{drv}^*",
            "--print-out-paths",
            *dict_to_flags(build_flags or {}),
        ],
        remote=build_host,
        stdout=PIPE,
    )
    return Path(r.stdout.strip())


def copy_closure(
    closure: Path,
    to_host: Remote | None,
    from_host: Remote | None = None,
    **copy_flags: Args,
) -> None:
    """Copy a nix closure to or from host to localhost.

    Also supports copying a closure from a remote to another remote."""
    host = to_host or from_host
    if not host:
        return

    sshopts = os.getenv("NIX_SSHOPTS", "")
    run_wrapper(
        [
            "nix-copy-closure",
            *dict_to_flags(copy_flags),
            "--to" if to_host else "--from",
            host.host,
            closure,
        ],
        extra_env={
            # Using raw NIX_SSHOPTS here to avoid messing up with the passed
            # parameters, and we do not add the SSH_DEFAULT_OPTS in the remote
            # to remote case, otherwise it will fail because of ControlPath
            # will not exist in remote
            "NIX_SSHOPTS": sshopts
            if from_host and to_host
            else " ".join(filter(lambda x: x, [*SSH_DEFAULT_OPTS, sshopts]))
        },
        remote=from_host if to_host else None,
    )


def edit(flake: Flake | None, **flake_flags: Args) -> None:
    "Try to find and open NixOS configuration file in editor."
    if flake:
        run_wrapper(
            [
                "nix",
                *FLAKE_FLAGS,
                "edit",
                *dict_to_flags(flake_flags),
                "--",
                str(flake),
            ],
            check=False,
        )
    else:
        if flake_flags:
            raise NRError("'edit' does not support extra Nix flags")
        nixos_config = Path(
            os.getenv("NIXOS_CONFIG") or find_file("nixos-config") or "/etc/nixos"
        )
        if nixos_config.is_dir():
            nixos_config /= "default.nix"

        if nixos_config.exists():
            run_wrapper([os.getenv("EDITOR", "nano"), nixos_config], check=False)
        else:
            raise NRError("cannot find NixOS config file")


def find_file(file: str, **nix_flags: Args) -> Path | None:
    "Find classic Nix file location."
    r = run_wrapper(
        ["nix-instantiate", "--find-file", file, *dict_to_flags(nix_flags)],
        stdout=PIPE,
        check=False,
    )
    if r.returncode:
        return None
    return Path(r.stdout.strip())


def get_nixpkgs_rev(nixpkgs_path: Path | None) -> str | None:
    """Get Nixpkgs path as a Git revision.

    Can be used to generate `.version-suffix` file."""
    if not nixpkgs_path:
        return None

    try:
        # Get current revision
        r = run_wrapper(
            ["git", "-C", nixpkgs_path, "rev-parse", "--short", "HEAD"],
            check=False,
            stdout=PIPE,
        )
    except FileNotFoundError:
        # Git is not included in the closure so we need to check
        logger.warning(f"Git not found; cannot figure out revision of '{nixpkgs_path}'")
        return None

    if rev := r.stdout.strip():
        # Check if repo is dirty
        if run_wrapper(
            ["git", "-C", nixpkgs_path, "diff", "--quiet"],
            check=False,
        ).returncode:
            rev += "M"
        return f".git.{rev}"
    else:
        return None


def _parse_generation_from_nix_store(path: Path, profile: Profile) -> Generation:
    entry_id = path.name.split("-")[1]
    current = path.name == profile.path.readlink().name
    timestamp = datetime.fromtimestamp(path.stat().st_ctime).strftime(
        "%Y-%m-%d %H:%M:%S"
    )

    return Generation(
        id=int(entry_id),
        timestamp=timestamp,
        current=current,
    )


def _parse_generation_from_nix_env(line: str) -> Generation:
    parts = line.split()

    entry_id = parts[0]
    timestamp = f"{parts[1]} {parts[2]}"
    current = "(current)" in parts

    return Generation(
        id=int(entry_id),
        timestamp=timestamp,
        current=current,
    )


def get_generations(
    profile: Profile,
    target_host: Remote | None = None,
    using_nix_env: bool = False,
    sudo: bool = False,
) -> list[Generation]:
    """Get all NixOS generations from profile.

    Includes generation ID (e.g.: 1, 2), timestamp (e.g.: when it was created)
    and if this is the current active profile or not.

    If `lock_profile = True` this command will need root to run successfully.
    """
    if not profile.path.exists():
        raise NRError(f"no profile '{profile.name}' found")

    result = []
    if using_nix_env:
        # Using `nix-env --list-generations` needs root to lock the profile
        # TODO: do we actually need to lock profile for e.g.: rollback?
        # https://github.com/NixOS/nix/issues/5144
        r = run_wrapper(
            ["nix-env", "-p", profile.path, "--list-generations"],
            stdout=PIPE,
            remote=target_host,
            sudo=sudo,
        )
        for line in r.stdout.splitlines():
            result.append(_parse_generation_from_nix_env(line))
    else:
        assert not target_host, "target_host is not supported when using_nix_env=False"
        for p in profile.path.parent.glob("system-*-link"):
            result.append(_parse_generation_from_nix_store(p, profile))
    return sorted(result, key=lambda d: d.id)


def list_generations(profile: Profile) -> list[GenerationJson]:
    """Get all NixOS generations from profile, including extra information.

    Includes OS information like the commit, kernel version, configuration
    revision and specialisations.

    Will be formatted in a way that is expected by the output of
    `nixos-rebuild list-generations --json`.
    """
    generations = get_generations(profile)
    result = []
    for generation in reversed(generations):
        generation_path = (
            profile.path.parent / f"{profile.path.name}-{generation.id}-link"
        )
        try:
            nixos_version = (generation_path / "nixos-version").read_text().strip()
        except IOError as ex:
            logger.debug("could not get nixos-version: %s", ex)
            nixos_version = "Unknown"
        try:
            kernel_version = next(
                (generation_path / "kernel-modules/lib/modules").iterdir()
            ).name
        except IOError as ex:
            logger.debug("could not get kernel version: %s", ex)
            kernel_version = "Unknown"
        specialisations = [
            s.name for s in (generation_path / "specialisation").glob("*") if s.is_dir()
        ]
        try:
            configuration_revision = run_wrapper(
                [generation_path / "sw/bin/nixos-version", "--configuration-revision"],
                capture_output=True,
            ).stdout.strip()
        except (CalledProcessError, IOError) as ex:
            logger.debug("could not get configuration revision: %s", ex)
            configuration_revision = "Unknown"

        result.append(
            GenerationJson(
                generation=generation.id,
                date=generation.timestamp,
                nixosVersion=nixos_version,
                kernelVersion=kernel_version,
                configurationRevision=configuration_revision,
                specialisations=specialisations,
                current=generation.current,
            )
        )

    return result


def repl(attr: str, build_attr: BuildAttr, **nix_flags: Args) -> None:
    run_args = ["nix", "repl", "--file", build_attr.path]
    if build_attr.attr:
        run_args.append(build_attr.attr)
    run_wrapper([*run_args, *dict_to_flags(nix_flags)])


def repl_flake(attr: str, flake: Flake, **flake_flags: Args) -> None:
    expr = Template(
        files(__package__).joinpath(FLAKE_REPL_TEMPLATE).read_text()
    ).substitute(
        flake=flake,
        flake_path=flake.path.resolve() if isinstance(flake.path, Path) else flake.path,
        flake_attr=flake.attr,
        bold="\033[1m",
        blue="\033[34;1m",
        attention="\033[35;1m",
        reset="\033[0m",
    )
    run_wrapper(
        [
            "nix",
            *FLAKE_FLAGS,
            "repl",
            "--impure",
            "--expr",
            expr,
            *dict_to_flags(flake_flags),
        ]
    )


def rollback(profile: Profile, target_host: Remote | None, sudo: bool) -> Path:
    "Rollback Nix profile, like one created by `nixos-rebuild switch`."
    run_wrapper(
        ["nix-env", "--rollback", "-p", profile.path],
        remote=target_host,
        sudo=sudo,
    )
    # Rollback config PATH is the own profile
    return profile.path


def rollback_temporary_profile(
    profile: Profile,
    target_host: Remote | None,
    sudo: bool,
) -> Path | None:
    "Rollback a temporary Nix profile, like one created by `nixos-rebuild test`."
    generations = get_generations(
        profile,
        target_host=target_host,
        using_nix_env=True,
        sudo=sudo,
    )
    previous_gen_id = None
    for generation in generations:
        if not generation.current:
            previous_gen_id = generation.id

    if previous_gen_id:
        return profile.path.parent / f"{profile.name}-{previous_gen_id}-link"
    else:
        return None


def set_profile(
    profile: Profile,
    path_to_config: Path,
    target_host: Remote | None,
    sudo: bool,
) -> None:
    "Set a path as the current active Nix profile."
    run_wrapper(
        ["nix-env", "-p", profile.path, "--set", path_to_config],
        remote=target_host,
        sudo=sudo,
    )


def switch_to_configuration(
    path_to_config: Path,
    action: Action,
    target_host: Remote | None,
    sudo: bool,
    install_bootloader: bool = False,
    specialisation: str | None = None,
) -> None:
    """Call `<config>/bin/switch-to-configuration <action>`.

    Expects a built path to run, like one generated with `nixos_build` or
    `nixos_build_flake` functions.
    """
    if specialisation:
        if action not in (Action.SWITCH, Action.TEST):
            raise NRError(
                "'--specialisation' can only be used with 'switch' and 'test'"
            )
        path_to_config = path_to_config / f"specialisation/{specialisation}"

        if not path_to_config.exists():
            raise NRError(f"specialisation not found: {specialisation}")

    run_wrapper(
        [path_to_config / "bin/switch-to-configuration", str(action)],
        extra_env={"NIXOS_INSTALL_BOOTLOADER": "1" if install_bootloader else "0"},
        remote=target_host,
        sudo=sudo,
    )


def upgrade_channels(all: bool = False) -> None:
    """Upgrade channels for classic Nix.

    It will either upgrade just the `nixos` channel (including any channel
    that has a `.update-on-nixos-rebuild` file) or all.
    """
    for channel_path in Path("/nix/var/nix/profiles/per-user/root/channels/").glob("*"):
        if channel_path.is_dir() and (
            all
            or channel_path.name == "nixos"
            or (channel_path / ".update-on-nixos-rebuild").exists()
        ):
            run_wrapper(["nix-channel", "--update", channel_path.name], check=False)
