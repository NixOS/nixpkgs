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
class NeededLibsDetector(GroupableFeatureDetector[LibSoName]):
    """
    Either:

    - List of libs needed by the given libraries.
    - Mapping from subdirectory name to list of libs needed by the libraries in that subdirectory.
    """

    dir: Path = Path("lib")
    ignored_dirs: Set[Path] = field(default_factory=lambda: set(map(Path, ("stubs", "cmake", "Win32", "x64"))))

    @staticmethod
    @override
    def path_feature_detector(path: Path) -> Set[LibSoName]:
        """
        Returns a values equivalent to the following bash snippet:

        ```console
        $ patchelf --print-needed ./libcusolver/lib/libcusolver.so
        libdl.so.2
        libcublas.so.11
        libcublasLt.so.11
        librt.so.1
        libpthread.so.0
        libm.so.6
        libgcc_s.so.1
        libc.so.6
        ld-linux-x86-64.so.2
        ```
        """
        logger.debug("Running patchelf --print-needed on %s...", path)
        start_time = time.time()
        result = subprocess.run(
            ["patchelf", "--print-needed", path],
            capture_output=True,
            check=True,
        )
        end_time = time.time()
        logger.debug("Ran patchelf --print-needed on %s in %s seconds.", path, end_time - start_time)
        libs_needed: set[LibSoName] = {
            LibSoNameTA.validate_python(name) for name in result.stdout.decode("utf-8").splitlines() if name
        }
        logger.debug("Libs needed: %s.", libs_needed)
        return libs_needed

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
