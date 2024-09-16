from abc import ABC, abstractmethod
from pathlib import Path


class FeatureDetector[T](ABC):
    """
    A generic feature detector which can detect the presence of a type `T` within a Nix store path.

    1. Retrieves a list of paths of interest using `gather`.
    2. Applies
    """

    @abstractmethod
    def find(self, store_path: Path) -> None | T:
        raise NotImplementedError

    def detect(self, store_path: Path) -> bool:
        return self.find(store_path) is not None
