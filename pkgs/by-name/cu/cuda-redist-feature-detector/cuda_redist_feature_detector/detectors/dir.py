from dataclasses import dataclass
from itertools import chain
from logging import Logger
from pathlib import Path
from typing import Final, override

from cuda_redist_lib.logger import get_logger

from .types import FeatureDetector
from .utilities import (
    cached_path_exists,
    cached_path_has_contents,
    cached_path_is_dir,
)

logger: Final[Logger] = get_logger(__name__)


@dataclass
class DirDetector(FeatureDetector[Path]):
    """
    Detects the presence of non-empty directory.
    """

    dir: Path

    @override
    def find(self, store_path: Path) -> None | Path:
        """
        Finds the path to a non-empty directory within the given Nix store path.
        """
        dir_path = store_path / self.dir
        satisfied = all(
            all(test(parent) for test in (cached_path_exists, cached_path_has_contents, cached_path_is_dir))
            # Get parents from root to path (reverse order), starting with the store path.
            # This excludes the parents of the store path, like `/`, `/nix`, and `/nix/store`.
            for parent in chain(dir_path.parents[::-1], (dir_path,))
            if parent.is_relative_to(store_path)
        )
        if satisfied:
            logger.debug("Found non-empty directory %s.", dir_path)
        else:
            logger.debug("Did not find non-empty directory %s.", dir_path)
        return dir_path if satisfied else None
