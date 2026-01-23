import json as json
import sys as sys

from .lib import debug, load_json
from .flatten_references_graph import flatten_references_graph


def main_impl(file_path):
    debug(f"loading json from {file_path}")

    data = load_json(file_path)

    # These are required
    references_graph = data["graph"]
    pipeline = data["pipeline"]

    # This is optional
    exclude_paths = data.get("exclude_paths")

    debug("references_graph", references_graph)
    debug("pipeline", pipeline)
    debug("exclude_paths", exclude_paths)

    result = flatten_references_graph(
        references_graph,
        pipeline,
        exclude_paths=exclude_paths
    )

    debug("result", result)

    return json.dumps(
        result,
        # For reproducibility.
        sort_keys=True,
        indent=2,
        # Avoid tailing whitespaces.
        separators=(",", ": ")
    )


def main():
    file_path = sys.argv[1]
    print(main_impl(file_path))


if __name__ == "__main__":
    main()
