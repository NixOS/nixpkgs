import argparse
import json
import numpy as np
import os
import pandas as pd
import warnings

from pathlib import Path
from scipy.stats import ttest_rel
from tabulate import tabulate


def flatten_data(json_data: dict) -> dict:
    """
    Extracts and flattens metrics from JSON data.
    This is needed because the JSON data can be nested.
    For example, the JSON data entry might look like this:

    "gc":{"cycles":13,"heapSize":5404549120,"totalBytes":9545876464}

    Flattened:

    "gc.cycles": 13
    "gc.heapSize": 5404549120
    ...

    Args:
        json_data (dict): JSON data containing metrics.
    Returns:
        dict: Flattened metrics with keys as metric names.
    """
    flat_metrics = {}
    for key, value in json_data.items():
        if isinstance(value, (int, float)):
            flat_metrics[key] = value
        elif isinstance(value, dict):
            for subkey, subvalue in value.items():
                assert isinstance(subvalue, (int, float)), subvalue
                flat_metrics[f"{key}.{subkey}"] = subvalue
        else:
            assert isinstance(value, (float, int, dict)), (
                f"Value `{value}` has unexpected type"
            )

    return flat_metrics


def load_all_metrics(path: Path) -> dict:
    """
    Loads all stats JSON files in the specified file or directory and extracts metrics.
    These stats JSON files are created by Nix when the `NIX_SHOW_STATS` environment variable is set.

    If the provided path is a directory, it must have the structure $path/$system/$stats,
    where $path is the provided path, $system is some system from `lib.systems.doubles.*`,
    and $stats is a stats JSON file.

    If the provided path is a file, it is a stats JSON file.

    Args:
        path (Path): Directory containing JSON files or a stats JSON file.

    Returns:
        dict: Dictionary with filenames as keys and extracted metrics as values.
    """
    metrics = {}
    if path.is_dir():
        for system_dir in path.iterdir():
            assert system_dir.is_dir()

            for chunk_output in system_dir.iterdir():
                with chunk_output.open() as f:
                    data = json.load(f)

                metrics[f"{system_dir.name}/${chunk_output.name}"] = flatten_data(data)
    else:
        with path.open() as f:
            metrics[path.name] = flatten_data(json.load(f))

    return metrics


def metric_sort_key(name: str) -> str:
    if name in ("cpuTime", "time.cpu", "time.gc", "time.gcFraction"):
        return (1, name)
    elif name.startswith("gc"):
        return (2, name)
    else:
        return (3, name)


def dataframe_to_markdown(df: pd.DataFrame) -> str:
    df = df.sort_values(
        by=df.columns[0], ascending=True, key=lambda s: s.map(metric_sort_key)
    )

    # Header (get column names and format them)
    headers = [str(column) for column in df.columns]
    table = [
        [
            row["metric"],
            # Check for no change and NaN in p_value/t_stat
            *[None if np.isnan(val) or np.allclose(val, 0) else val for val in row[1:]],
        ]
        for _, row in df.iterrows()
    ]

    return tabulate(table, headers, tablefmt="github", floatfmt=".4f", missingval="-")


def perform_pairwise_tests(before_metrics: dict, after_metrics: dict) -> pd.DataFrame:
    common_files = sorted(set(before_metrics) & set(after_metrics))
    all_keys = sorted(
        {
            metric_keys
            for file_metrics in before_metrics.values()
            for metric_keys in file_metrics.keys()
        }
    )
    results = []

    for key in all_keys:
        before_vals = []
        after_vals = []

        for fname in common_files:
            if key in before_metrics[fname] and key in after_metrics[fname]:
                before_vals.append(before_metrics[fname][key])
                after_vals.append(after_metrics[fname][key])

        if len(before_vals) == 0:
            continue

        before_arr = np.array(before_vals)
        after_arr = np.array(after_vals)

        diff = after_arr - before_arr
        pct_change = 100 * diff / before_arr

        # If there are enough values to perform a t-test, do so, otherwise mark NaN
        if len(before_vals) == 1:
            t_stat, p_val = [float("NaN")] * 2
        else:
            t_stat, p_val = ttest_rel(after_arr, before_arr)

        results.append(
            {
                "metric": key,
                "mean_before": np.mean(before_arr),
                "mean_after": np.mean(after_arr),
                "mean_diff": np.mean(diff),
                "mean_%_change": np.mean(pct_change),
                "p_value": p_val,
                "t_stat": t_stat,
            }
        )

    df = pd.DataFrame(results).sort_values("p_value")
    return df


def main():
    parser = argparse.ArgumentParser(
        description="Performance comparison of Nix evaluation statistics"
    )
    parser.add_argument(
        "before", help="File or directory containing baseline (data before)"
    )
    parser.add_argument(
        "after", help="File or directory containing comparison (data after)"
    )

    options = parser.parse_args()

    # Turn warnings into errors
    warnings.simplefilter("error")

    before_stats = Path(options.before)
    after_stats = Path(options.after)

    before_metrics = load_all_metrics(before_stats)
    after_metrics = load_all_metrics(after_stats)
    df1 = perform_pairwise_tests(before_metrics, after_metrics)
    markdown_table = dataframe_to_markdown(df1)
    print(markdown_table)


if __name__ == "__main__":
    main()
