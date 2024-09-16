from collections.abc import Sequence
from dataclasses import dataclass
from logging import Logger
from pathlib import Path
from typing import Final, override

from cuda_redist_lib.logger import get_logger

from .dir import DirDetector
from .types import FeatureDetector
from .utilities import cached_path_rglob

logger: Final[Logger] = get_logger(__name__)


@dataclass
class StubsDetector(FeatureDetector[Sequence[Path]]):
    """
    Detects the presence of stubs libraries in the `lib` or `stubs` directories.
    """

    @override
    def find(self, store_path: Path) -> None | Sequence[Path]:
        """
        Finds paths of stub libraries under `lib` or `stubs` within the given Nix store path.
        """
        lib_stubs_dir = DirDetector(Path("lib") / "stubs").find(store_path)
        stubs_dir = DirDetector(Path("stubs")).find(store_path)
        if lib_stubs_dir is None and stubs_dir is None:
            return None

        libraries: list[Path] = []
        if lib_stubs_dir is not None:
            libraries.extend(cached_path_rglob(lib_stubs_dir, "*.so", files_only=True))
            libraries.extend(cached_path_rglob(lib_stubs_dir, "*.a", files_only=True))
        if stubs_dir is not None:
            libraries.extend(cached_path_rglob(stubs_dir, "*.so", files_only=True))
            libraries.extend(cached_path_rglob(stubs_dir, "*.a", files_only=True))

        libraries.sort()
        if [] != libraries:
            logger.debug("Found stubs libraries: %s.", libraries)
            return libraries

        return None
