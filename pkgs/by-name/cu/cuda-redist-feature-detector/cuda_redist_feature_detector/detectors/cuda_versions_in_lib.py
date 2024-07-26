import re
from collections.abc import Sequence
from dataclasses import dataclass
from logging import Logger
from pathlib import Path
from typing import Final, override

from cuda_redist_lib.logger import get_logger

from .dir import DirDetector
from .types import FeatureDetector

logger: Final[Logger] = get_logger(__name__)


@dataclass
class CudaVersionsInLibDetector(FeatureDetector[Sequence[Path]]):
    """
    Detects the presence of non-empty directories under `lib` with the names of CUDA versions.
    """

    @override
    def find(self, store_path: Path) -> None | Sequence[Path]:
        """
        Finds paths of non-empty directories under `lib` with the names of CUDA versions.
        """
        lib_dir = DirDetector(Path("lib")).find(store_path)
        if lib_dir is None:
            return None

        cuda_version_pattern = re.compile(r"^\d+(?:\.\d+)?$")
        lib_subdirs = sorted(
            subdir.relative_to(lib_dir)
            for path in lib_dir.iterdir()
            if path.is_dir()
            and (subdir := DirDetector(path).find(lib_dir)) is not None
            and cuda_version_pattern.match(subdir.name)
        )

        if [] != lib_subdirs:
            logger.debug("Found non-empty subdirectories under `lib`: %s.", lib_subdirs)
            return lib_subdirs

        return None
