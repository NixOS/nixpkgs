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
class HeaderDetector(FeatureDetector[Sequence[Path]]):
    """
    Detects the presence of headers in the `include` directory.
    """

    @override
    def find(self, store_path: Path) -> None | Sequence[Path]:
        """
        Finds paths of headers under `include` within the given Nix store path.
        """
        include_dir = DirDetector(Path("include")).find(store_path)
        if include_dir is None:
            return None

        headers = [
            header
            for header in cached_path_rglob(include_dir, "*.*h*", files_only=True)
            if header.suffix in {".h", ".hh", ".cuh", ".hpp", ".hxx"}
        ]
        if [] != headers:
            logger.debug("Found headers: %s.", headers)
            return headers

        return None
