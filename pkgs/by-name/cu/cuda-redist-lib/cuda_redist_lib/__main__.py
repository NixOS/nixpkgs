import json
import os
from pathlib import Path

from cuda_redist_lib.index import mk_index


def main() -> None:
    TENSORRT_MANIFEST_DIR: None | str = os.getenv("TENSORRT_MANIFEST_DIR", None)
    if not TENSORRT_MANIFEST_DIR:
        raise ValueError("TENSORRT_MANIFEST_DIR must be set")

    with open(
        Path(".")
        / "pkgs"
        / "development"
        / "cuda-modules"
        / "redist-index"
        / "data"
        / "indices"
        / "sha256-and-relative-path.json",
        "w",
        encoding="utf-8",
    ) as file:
        json.dump(
            mk_index().model_dump(
                by_alias=True,
                exclude_none=True,
                exclude_unset=True,
                mode="json",
            ),
            file,
            indent=2,
            sort_keys=True,
        )
        file.write("\n")


if __name__ == "__main__":
    main()
