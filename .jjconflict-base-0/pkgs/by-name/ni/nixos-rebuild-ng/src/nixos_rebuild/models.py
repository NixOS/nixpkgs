from __future__ import annotations

import platform
import re
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Any, ClassVar, TypedDict, override


class NRError(Exception):
    "nixos-rebuild general error."

    def __init__(self, message: str):
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
class Flake:
    path: Path
    attr: str
    _re: ClassVar = re.compile(r"^(?P<path>[^\#]*)\#?(?P<attr>[^\#\"]*)$")

    @override
    def __str__(self) -> str:
        return f"{self.path}#{self.attr}"

    @classmethod
    def parse(cls, flake_str: str, hostname: str | None = None) -> Flake:
        m = cls._re.match(flake_str)
        assert m is not None, f"got no matches for {flake_str}"
        attr = m.group("attr")
        nixos_attr = f"nixosConfigurations.{attr or hostname or "default"}"
        return Flake(Path(m.group("path")), nixos_attr)

    @classmethod
    def from_arg(cls, flake_arg: Any) -> Flake | None:
        hostname = platform.node()
        match flake_arg:
            case str(s):
                return cls.parse(s, hostname)
            case True:
                return cls.parse(".", hostname)
            case False:
                return None
            case _:
                # Use /etc/nixos/flake.nix if it exists.
                default_path = Path("/etc/nixos/flake.nix")
                if default_path.exists():
                    # It can be a symlink to the actual flake.
                    if default_path.is_symlink():
                        default_path = default_path.readlink()
                    return cls.parse(str(default_path.parent), hostname)
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

    @staticmethod
    def from_name(name: str = "system") -> Profile:
        match name:
            case "system":
                return Profile(name, Path("/nix/var/nix/profiles/system"))
            case _:
                path = Path("/nix/var/nix/profiles/system-profiles") / name
                path.parent.mkdir(mode=0o755, parents=True, exist_ok=True)
                return Profile(name, path)
