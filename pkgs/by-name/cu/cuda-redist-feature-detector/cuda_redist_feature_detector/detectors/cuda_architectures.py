import re
import subprocess
import time
from collections.abc import Mapping, Sequence, Set
from dataclasses import dataclass, field
from logging import Logger
from pathlib import Path
from typing import Final, override

from cuda_redist_lib.extra_types import CudaArch, CudaArchTA
from cuda_redist_lib.logger import get_logger

from .groupable_feature_detector import GroupableFeatureDetector

logger: Final[Logger] = get_logger(__name__)


@dataclass
class CudaArchitecturesDetector(GroupableFeatureDetector[CudaArch]):
    """
    Either:

    - List of architectures supported by the given libraries.
    - Mapping from subdirectory name to list of architectures supported by the libraries in that subdirectory.
    """

    dir: Path = Path("lib")
    ignored_dirs: Set[Path] = field(default_factory=lambda: set(map(Path, ("stubs", "cmake", "Win32", "x64"))))

    @staticmethod
    @override
    def path_feature_detector(path: Path) -> Set[CudaArch]:
        """
        Equivalent to the following bash snippet, sans ordering:

        ```console
        $ cuobjdump libcublas.so | grep 'arch =' | sort -u
        arch = sm_35
        ...
        arch = sm_86
        arch = sm_90
        ```
        """
        logger.debug("Running cuobjdmp on %s...", path)
        start_time = time.time()
        result = subprocess.run(
            ["cuobjdump", path],
            capture_output=True,
            check=False,
        )
        end_time = time.time()
        logger.debug("Ran cuobjdump on %s in %d seconds.", path, end_time - start_time)

        # Handle failure and the case where the library is GPU-agnostic.
        if result.returncode != 0:
            err_msg = result.stderr.decode("utf-8")
            if "does not contain device code" in err_msg:
                logger.debug("%s is GPU-agnostic.", path)
                return set()

            raise RuntimeError(f"Failed to run cuobjdump on {path}: {err_msg}")

        output = result.stdout.decode("utf-8")
        architecture_strs: set[str] = set(re.findall(r"^arch = (.+)$", output, re.MULTILINE))
        architectures: set[CudaArch] = set(map(CudaArchTA.validate_python, architecture_strs))
        logger.debug("Found architectures: %s", architectures)
        return architectures

    @staticmethod
    @override
    def path_filter(path: Path) -> bool:
        return path.suffix == ".so"

    @override
    def find(self, store_path: Path) -> None | Sequence[CudaArch] | Mapping[str, Sequence[CudaArch]]:
        logger.debug("Getting supported CUDA architectures for %s...", store_path)
        start_time = time.time()
        ret = super().find(store_path)
        end_time = time.time()
        logger.debug("Got supported CUDA architectures for %s in %d seconds.", store_path, end_time - start_time)
        return ret
