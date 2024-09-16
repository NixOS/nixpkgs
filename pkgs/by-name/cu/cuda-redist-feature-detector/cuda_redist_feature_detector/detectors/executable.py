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
class ExecutableDetector(FeatureDetector[Sequence[Path]]):
    """
    Detects the presence of an executable in the `bin` directory.
    """

    @staticmethod
    def file_is_unix_executable(file: Path) -> bool:
        return bool(file.stat().st_mode | 0o111)

    @staticmethod
    def file_is_windows_executable(file: Path) -> bool:
        # Yes, I know DLLs are not executables, but they are okay to exist in the bin directory.
        return file.suffix in {".bat", ".dll", ".exe"}

    @override
    def find(self, store_path: Path) -> None | Sequence[Path]:
        """
        Finds paths of executables under `bin` within the given Nix store path.
        """
        bin_dir = DirDetector(Path("bin")).find(store_path)
        if bin_dir is None:
            return None

        executables = [
            executable
            for executable in cached_path_rglob(bin_dir, "*", files_only=True)
            if any(
                test(executable)
                for test in (ExecutableDetector.file_is_unix_executable, ExecutableDetector.file_is_windows_executable)
            )
        ]
        if [] != executables:
            logger.debug("Found executables: %s.", executables)
            return executables

        return None
