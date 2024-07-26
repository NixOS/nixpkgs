from collections.abc import Sequence
from pathlib import Path
from typing import Self

from cuda_redist_lib.extra_pydantic import PydanticSequence

from cuda_redist_feature_detector.detectors import CudaVersionsInLibDetector


class FeatureCudaVersionsInLib(PydanticSequence[str]):
    """
    A sequence of subdirectories of `lib` named after CUDA versions present in a CUDA redistributable package.
    """

    @classmethod
    def of(cls, store_path: Path) -> Self:
        paths: None | Sequence[Path] = CudaVersionsInLibDetector().find(store_path)
        return cls([] if paths is None else [path.as_posix() for path in paths])
