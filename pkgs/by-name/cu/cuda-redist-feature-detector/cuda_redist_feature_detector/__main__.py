import concurrent.futures
import json
import sys
from argparse import ArgumentParser, Namespace
from functools import partial
from logging import Logger
from pathlib import Path
from typing import Any, Final

from cuda_redist_lib.logger import get_logger
from pydantic import BaseModel

from cuda_redist_feature_detector.cuda_versions_in_lib import FeatureCudaVersionsInLib
from cuda_redist_feature_detector.outputs import FeatureOutputs

logger: Final[Logger] = get_logger(__name__)


def setup_argparse() -> ArgumentParser:
    parser: ArgumentParser = ArgumentParser()
    mutex_group = parser.add_mutually_exclusive_group(required=True)
    mutex_group.add_argument(
        "--store-path", type=Path, help="Store path to provide to the feature detector. Outputs a feature blob."
    )
    mutex_group.add_argument(
        "--stdin", action="store_true", help="Read store paths from stdin. Outputs a map from store path to features."
    )
    return parser


def process_store_path(store_path: Path) -> dict[str, Any]:
    outputs = FeatureOutputs.of(store_path)
    cuda_versions_in_lib = FeatureCudaVersionsInLib.of(store_path)
    dump_model = partial(BaseModel.model_dump, by_alias=True, exclude_none=True, exclude_unset=True, mode="json")
    return {
        "outputs": dump_model(outputs),
        "cudaVersionsInLib": dump_model(cuda_versions_in_lib) if cuda_versions_in_lib else None,
    }


def main() -> None:
    args: Namespace = setup_argparse().parse_args()
    if args.store_path:
        features = process_store_path(args.store_path)
        print(json.dumps(features, indent=2, sort_keys=True))
        return

    # Case where we handle stdin
    feature_map: dict[str, dict[str, Any]] = {}
    with concurrent.futures.ProcessPoolExecutor() as executor:
        # Get all of the manifests in parallel.
        futures = {
            executor.submit(process_store_path, Path(store_path)): store_path
            for store_path in map(str.rstrip, sys.stdin)
        }
        num_tasks = len(futures)
        logger.info("Processing %d store paths...", num_tasks)
        for future in concurrent.futures.as_completed(futures):
            store_path = futures[future]
            try:
                feature = future.result()
                feature_map[store_path] = feature
                logger.info("Processed %s", store_path)
            except Exception as e:
                raise RuntimeError(f"Error processing {store_path}: {e}")

    print(json.dumps(feature_map, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
