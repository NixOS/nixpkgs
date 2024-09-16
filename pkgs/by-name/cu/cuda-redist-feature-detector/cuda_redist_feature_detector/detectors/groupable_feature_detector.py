from abc import abstractmethod
from collections.abc import Iterable, Mapping, Sequence, Set
from dataclasses import dataclass
from functools import reduce
from logging import Logger
from pathlib import Path
from typing import TYPE_CHECKING, Final, TypeVar, cast

from cuda_redist_lib.logger import get_logger

from .dir import DirDetector
from .types import FeatureDetector
from .utilities import cached_path_is_dir, cached_path_iterdir

logger: Final[Logger] = get_logger(__name__)

if TYPE_CHECKING:
    from _typeshed import SupportsRichComparison

    RichlyComparable = TypeVar("RichlyComparable", bound=SupportsRichComparison)
else:
    RichlyComparable = TypeVar("RichlyComparable")


@dataclass
class GroupableFeatureDetector(FeatureDetector[Sequence[RichlyComparable] | Mapping[str, Sequence[RichlyComparable]]]):
    """
    A detector that detects a feature or a group of features. Given a directory, ensures that there are subdirectories
    if and only if there are no files directly under the directory. In the case there are no subdirectories, the
    detector will return a list of features. In the case there are subdirectories, the detector will return a
    dictionary mapping each subdirectory to a list of features.
    """

    dir: Path
    ignored_dirs: Set[Path]

    @staticmethod
    @abstractmethod
    def path_feature_detector(path: Path) -> Set[RichlyComparable]:
        raise NotImplementedError

    @staticmethod
    @abstractmethod
    def path_filter(path: Path) -> bool:
        raise NotImplementedError

    def paths_func(self, paths: Iterable[Path]) -> Sequence[RichlyComparable]:
        """
        Operates on a list of paths and accumulates the results of `self.path_feature_detector` on each path.

        Applies `self.path_filter` to each path before passing it to `self.path_feature_detector`.

        Returns a sorted, deduplicated list of features.
        """
        return sorted(
            reduce(
                set.union,  # type: ignore[arg-type]
                map(self.path_feature_detector, filter(self.path_filter, paths)),
                cast(set[RichlyComparable], set()),
            )
        )

    def find(self, store_path: Path) -> None | Sequence[RichlyComparable] | Mapping[str, Sequence[RichlyComparable]]:
        # Ensure that store_path is a directory which exists and is non-empty.
        absolute_dir: None | Path = DirDetector(self.dir).find(store_path)
        if absolute_dir is None:
            return None

        # Get rid of the ignored directories.
        absolute_ignored_dirs = {absolute_dir / ignored_dir for ignored_dir in self.ignored_dirs}

        items: list[Path] = []

        for item in cached_path_iterdir(absolute_dir):
            if cached_path_is_dir(item):
                if item in absolute_ignored_dirs:
                    logger.debug("Skipping ignored directory %s...", item)
                else:
                    logger.debug("Found subdirectory %s...", item)
                    items.append(item)
            elif not self.path_filter(item):
                logger.debug("Skipping ignored file %s...", item)
            else:
                logger.debug("Found file %s...", item)
                items.append(item)

        # If there are no items, return None.
        if [] == items:
            return None

        # If there are no subdirectories, return a list of features.
        if all(item.is_file() for item in items):
            return self.paths_func(items)

        # If there are no files, return a dictionary mapping each subdirectory to a list of features.
        if all(item.is_dir() for item in items):
            return {
                subdir.relative_to(absolute_dir).as_posix(): self.paths_func(cached_path_iterdir(subdir))
                for subdir in items
            }

        raise RuntimeError(f"Found both subdirectories and items directly under {absolute_dir}: {items}.")
