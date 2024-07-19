import subprocess
import time
from collections.abc import Mapping, Sequence, Set
from dataclasses import dataclass, field
from logging import Logger
from pathlib import Path
from typing import Final, override

from cuda_redist_lib.extra_types import LibSoName, LibSoNameTA
from cuda_redist_lib.logger import get_logger

from .groupable_feature_detector import GroupableFeatureDetector

logger: Final[Logger] = get_logger(__name__)


@dataclass
class ProvidedLibsDetector(GroupableFeatureDetector[LibSoName]):
    """
    Either:

    - List of libs provided by the given libraries.
    - Mapping from subdirectory name to list of libs provided by the libraries in that subdirectory.
    """

    dir: Path = Path("lib")
    ignored_dirs: Set[Path] = field(default_factory=lambda: set(map(Path, ("stubs", "cmake", "Win32", "x64"))))

    @staticmethod
    @override
    def path_feature_detector(path: Path) -> Set[LibSoName]:
        """
        Returns the soname of the given library.

        The value is equivalent to the following bash snippet:

        ```console
        $ patchelf --print-soname ./libcusolver/lib/libcusolver.so
        libcusolver.so.11
        ```
        """
        logger.debug("Running patchelf --print-soname on %s...", path)
        start_time = time.time()
        result = subprocess.run(
            ["patchelf", "--print-soname", path],
            capture_output=True,
            check=True,
        )
        end_time = time.time()
        logger.debug("Ran patchelf --print-soname on %s in %s seconds.", path, end_time - start_time)
        name: str = result.stdout.decode("utf-8").strip()
        if name:
            lib_so_name: LibSoName = LibSoNameTA.validate_python(name)
            logger.debug("Lib soname: %s.", lib_so_name)
            return set((lib_so_name,))
        else:
            logger.info("No lib soname found for %s.", path)
            return set()

    @staticmethod
    @override
    def path_filter(path: Path) -> bool:
        return path.suffix == ".so"

    @override
    def find(self, store_path: Path) -> None | Sequence[LibSoName] | Mapping[str, Sequence[LibSoName]]:
        logger.debug("Getting needed libs for %s...", store_path)
        start_time = time.time()
        ret = super().find(store_path)
        end_time = time.time()
        logger.debug("Got needed libs for %s in %s seconds.", store_path, end_time - start_time)
        return ret
