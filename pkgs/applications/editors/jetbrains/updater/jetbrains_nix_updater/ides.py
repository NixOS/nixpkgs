import sys

from subprocess import CalledProcessError
from typing import Iterable, TypedDict

import dataclasses
from pathlib import Path

from jetbrains_nix_updater.util import run_command


class UpdateInfo(TypedDict):
    channel: str
    urls: dict[str, str]


@dataclasses.dataclass(slots=True)
class Ide:
    name: str
    drv_path: Path
    is_source: bool
    update_info: UpdateInfo | None


def by_name_path(ide_name: str, nixpkgs_root: Path) -> Path:
    by_name_stem = ide_name[0:2]
    return nixpkgs_root / "pkgs" / "by-name" / by_name_stem / ide_name


def is_source_ide(ide_name: str):
    return ide_name.endswith("-oss")


def get_single_ide(update_info: dict[str, UpdateInfo], nixpkgs_root: Path, name: str) -> Ide:
    drv_path = by_name_path(name, nixpkgs_root) / "package.nix"
    if not drv_path.exists():
        raise Exception(f"IDE not found at {drv_path}")
    return Ide(
        name=name,
        drv_path=drv_path,
        is_source=is_source_ide(name),
        update_info=update_info.get(name),
    )


def get_all_ides(update_info: dict[str, UpdateInfo], nixpkgs_root: Path) -> Iterable[Ide]:
    for name, update_info in update_info.items():
        drv_path = by_name_path(name, nixpkgs_root) / "package.nix"
        yield Ide(
            name=name,
            drv_path=drv_path,
            is_source=is_source_ide(name),
            update_info=update_info,
        )
