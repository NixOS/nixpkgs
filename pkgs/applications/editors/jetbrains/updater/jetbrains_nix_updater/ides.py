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


def is_source_ide(drv_path: Path):
    assert " " not in str(drv_path)
    try:
        return (
            run_command(
                [
                    "nix-instantiate",
                    "--eval",
                    "-E",
                    f'builtins.hasAttr "mkJetBrainsSource" (builtins.functionArgs (import {drv_path}))',
                ]
            )
            == "true"
        )
    except CalledProcessError as ex:
        print(f"Failed to eval {drv_path}: {ex.stderr}", file=sys.stderr)
        exit(1)


def get_single_ide(update_info: dict[str, UpdateInfo], jb_root: Path, name: str) -> Ide:
    drv_path = jb_root / "ides" / f"{name}.nix"
    if not drv_path.exists():
        raise Exception(f"IDE not found at {drv_path}")
    return Ide(
        name=name,
        drv_path=drv_path,
        is_source=is_source_ide(drv_path),
        update_info=update_info.get(name),
    )


def get_all_ides(update_info: dict[str, UpdateInfo], jb_root: Path) -> Iterable[Ide]:
    for file in sorted((jb_root / "ides").iterdir()):
        if file.suffix == ".nix":
            yield Ide(
                name=file.stem,
                drv_path=file,
                is_source=is_source_ide(file),
                update_info=update_info.get(file.stem),
            )
