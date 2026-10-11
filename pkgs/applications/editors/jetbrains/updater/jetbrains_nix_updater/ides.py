import dataclasses
from collections.abc import Iterable
from functools import cached_property
from pathlib import Path
from typing import Self, TypedDict


class MissingIdeException(Exception):
    "Raised when an IDE is not found"


class UpdateInfo(TypedDict):
    channel: str
    urls: dict[str, str]


@dataclasses.dataclass
class Ide:
    name: str
    drv_path: Path
    update_info: UpdateInfo | None

    @cached_property
    def is_source(self) -> bool:
        return self.name.endswith("-oss")

    @classmethod
    def get(
        cls,
        update_info: dict[str, UpdateInfo],
        nixpkgs_root: Path,
        name: str,
    ) -> Self:
        drv_path = by_name_path(name, nixpkgs_root) / "package.nix"
        if not drv_path.exists():
            raise MissingIdeException(f"IDE not found at {drv_path}")
        return cls(
            name=name,
            drv_path=drv_path,
            update_info=update_info.get(name),
        )

    @classmethod
    def get_all(
        cls,
        update_info: dict[str, UpdateInfo],
        nixpkgs_root: Path,
    ) -> Iterable[Self]:
        for name, info in update_info.items():
            drv_path = by_name_path(name, nixpkgs_root) / "package.nix"
            yield cls(
                name=name,
                drv_path=drv_path,
                update_info=info,
            )


def by_name_path(ide_name: str, nixpkgs_root: Path) -> Path:
    by_name_stem = ide_name[0:2]
    return nixpkgs_root / "pkgs" / "by-name" / by_name_stem / ide_name
