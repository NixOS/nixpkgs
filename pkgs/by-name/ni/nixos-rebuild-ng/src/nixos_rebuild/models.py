import platform
import re
import subprocess
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Any, Callable, ClassVar, Self, TypedDict, override

from .process import Remote, run_wrapper

type ImageVariants = list[str]


class NRError(Exception):
    "nixos-rebuild general error."

    def __init__(self, message: str) -> None:
        self.message = message

    @override
    def __str__(self) -> str:
        return f"error: {self.message}"


class Action(Enum):
    SWITCH = "switch"
    BOOT = "boot"
    TEST = "test"
    BUILD = "build"
    EDIT = "edit"
    REPL = "repl"
    DRY_BUILD = "dry-build"
    DRY_RUN = "dry-run"
    DRY_ACTIVATE = "dry-activate"
    BUILD_IMAGE = "build-image"
    BUILD_VM = "build-vm"
    BUILD_VM_WITH_BOOTLOADER = "build-vm-with-bootloader"
    LIST_GENERATIONS = "list-generations"

    @override
    def __str__(self) -> str:
        return self.value

    @staticmethod
    def values() -> list[str]:
        return [a.value for a in Action]


@dataclass(frozen=True)
class BuildAttr:
    path: str | Path
    attr: str | None

    def to_attr(self, *attrs: str) -> str:
        return f"{self.attr + '.' if self.attr else ''}{'.'.join(attrs)}"

    @classmethod
    def from_arg(cls, attr: str | None, file: str | None) -> Self:
        if not (attr or file):
            return cls("<nixpkgs/nixos>", None)
        return cls(Path(file or "default.nix"), attr)


@dataclass(frozen=True)
class Flake:
    path: Path | str
    attr: str
    _re: ClassVar = re.compile(r"^(?P<path>[^\#]*)\#?(?P<attr>[^\#\"]*)$")

    def to_attr(self, *attrs: str) -> str:
        return f"{self}.{'.'.join(attrs)}"

    @override
    def __str__(self) -> str:
        return f"{self.path}#{self.attr}"

    @classmethod
    def parse(
        cls,
        flake_str: str,
        hostname_fn: Callable[[], str | None] = lambda: None,
    ) -> Self:
        m = cls._re.match(flake_str)
        assert m is not None, f"got no matches for {flake_str}"
        attr = m.group("attr")
        nixos_attr = f'nixosConfigurations."{attr or hostname_fn() or "default"}"'
        path_str = m.group("path")
        if ":" in path_str:
            return cls(path_str, nixos_attr)
        else:
            # Since we use builtins.getFlake we have behavior differences
            # between normal nix build and the nix repl because
            # builtins.getFlake won't pick up local flakes as git+file
            # but assumes path:// flakes instead.
            # This can have surprising effects such as beeing able to access
            # untracked files that would lead to build failures otherwise
            # or copying large files to the nix store.
            # We could force git+file:// protocol to fix this, but thanks to
            # another issue in nix this causes a nasty issue where
            # nixos-rebuild is run inside a symlink to a nix store path
            # (e.g. /run/opengl-driver/lib).
            # See:
            # - https://github.com/NixOS/nixpkgs/pull/375493
            # - https://github.com/NixOS/nixpkgs/pull/410498
            # - https://github.com/NixOS/nixpkgs/issues/93694
            return cls(Path(path_str), nixos_attr)

    @classmethod
    def from_arg(cls, flake_arg: Any, target_host: Remote | None) -> Self | None:
        def get_hostname() -> str | None:
            if target_host:
                try:
                    return run_wrapper(
                        ["uname", "-n"],
                        stdout=subprocess.PIPE,
                        remote=target_host,
                    ).stdout.strip()
                except (AttributeError, subprocess.CalledProcessError):
                    return None
            else:
                return platform.node()

        match flake_arg:
            case str(s):
                return cls.parse(s, get_hostname)
            case True:
                return cls.parse(".", get_hostname)
            case False:
                return None
            case _:
                # Use /etc/nixos/flake.nix if it exists.
                default_path = Path("/etc/nixos/flake.nix")
                if default_path.exists():
                    # It can be a symlink to the actual flake.
                    default_path = default_path.resolve()
                    return cls.parse(str(default_path.parent), get_hostname)
                else:
                    return None


@dataclass(frozen=True)
class Generation:
    id: int
    timestamp: str  # we may want to have a proper timestamp type in future
    current: bool


# camelCase since this will be used as output for `--json` flag
class GenerationJson(TypedDict):
    generation: int
    date: str
    nixosVersion: str
    kernelVersion: str
    configurationRevision: str
    specialisations: list[str]
    current: bool


@dataclass(frozen=True)
class Profile:
    name: str
    path: Path

    @classmethod
    def from_arg(cls, name: str) -> Self:
        match name:
            case "system":
                return cls(name, Path("/nix/var/nix/profiles/system"))
            case _:
                path = Path("/nix/var/nix/profiles/system-profiles") / name
                path.parent.mkdir(mode=0o755, parents=True, exist_ok=True)
                return cls(name, path)
