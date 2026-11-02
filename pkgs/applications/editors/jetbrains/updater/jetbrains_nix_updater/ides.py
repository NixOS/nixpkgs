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
    package_dir: Path
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
        package_dir = by_name_path(name, nixpkgs_root)
        package_file = package_dir / "package.nix"
        if not package_file.exists():
            raise MissingIdeException(f"IDE not found at {package_file}")
        return cls(
            name=name,
            package_dir=package_dir,
            update_info=update_info.get(name),
        )

    @classmethod
    def get_all(
        cls,
        update_info: dict[str, UpdateInfo],
        nixpkgs_root: Path,
    ) -> Iterable[Self]:
        for name, info in update_info.items():
            yield cls(
                name=name,
                package_dir=by_name_path(name, nixpkgs_root),
                update_info=info,
            )


def by_name_path(ide_name: str, nixpkgs_root: Path) -> Path:
    by_name_stem = ide_name[0:2]
    return nixpkgs_root / "pkgs" / "by-name" / by_name_stem / ide_name
