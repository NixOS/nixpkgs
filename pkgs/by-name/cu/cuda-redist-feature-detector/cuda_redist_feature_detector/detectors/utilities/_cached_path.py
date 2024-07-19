from functools import lru_cache
from logging import Logger
from pathlib import Path
from typing import Final

from cuda_redist_lib.logger import get_logger

logger: Final[Logger] = get_logger(__name__)


def cache_hit_ratio(hits: int, misses: int, _maxsize: None | int, _currsize: int) -> float:
    calls = hits + misses
    return hits / calls if calls else 0.0


@lru_cache
def _exists(path: Path) -> bool:
    """
    Returns whether the given path exists.
    """
    return path.exists()


@lru_cache
def _is_dir(path: Path) -> bool:
    """
    Returns whether the given path is a directory.
    """
    return path.is_dir()


@lru_cache
def _iterdir(path: Path) -> list[Path]:
    """
    Returns the contents of the given path.
    """
    return sorted(path.iterdir())


@lru_cache
def _has_contents(path: Path) -> bool:
    """
    Returns whether the given path has contents.
    """
    return any(True for _ in path.iterdir())


@lru_cache
def _rglob(path: Path, pattern: str, files_only: bool = False) -> list[Path]:
    """
    Returns a list of paths matching the given patterns.
    """
    matched = path.rglob(pattern)
    if files_only:
        matched = (path for path in matched if path.is_file())
    return sorted(matched)


def exists(path: Path) -> bool:
    """
    Returns whether the given path exists.
    """
    path_exists = _exists(path)
    logger.debug("Path %s %s exist.", path, "does" if path_exists else "does not")
    return path_exists


def is_dir(path: Path) -> bool:
    """
    Returns whether the given path is a directory.
    """
    path_is_dir = _is_dir(path)
    logger.debug("Path %s %s a directory.", path, "is" if path_is_dir else "is not")
    return path_is_dir


def iterdir(path: Path) -> list[Path]:
    """
    Returns the contents of the given path.
    """
    path_iterdir = _iterdir(path)
    logger.debug("Path %s has %s contents.", path, len(path_iterdir))
    return path_iterdir


def has_contents(path: Path) -> bool:
    """
    Returns whether the given path has contents.
    """
    path_has_contents = _has_contents(path)
    logger.debug("Path %s %s contents.", path, "has" if path_has_contents else "does not have")
    return path_has_contents


def rglob(path: Path, pattern: str, files_only: bool = False) -> list[Path]:
    """
    Returns a list of paths matching the given patterns.
    """
    matched = _rglob(path, pattern, files_only)
    logger.debug("Path %s has %s matches for pattern %s.", path, len(matched), pattern)
    return matched
