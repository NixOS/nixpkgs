import json
import os
from scipy.stats import ttest_rel
import pandas as pd
import numpy as np
from pathlib import Path

# Define metrics of interest (can be expanded as needed)
METRIC_PREFIXES = ("nr", "gc")

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
    for k, v in json_data.items():
        if isinstance(v, (int, float)):
            flat_metrics[k] = v
        elif isinstance(v, dict):
            for sub_k, sub_v in v.items():
                flat_metrics[f"{k}.{sub_k}"] = sub_v
    return flat_metrics




def load_all_metrics(directory: Path) -> dict:
    """
    Loads all stats JSON files in the specified directory and extracts metrics.

    Args:
        directory (Path): Directory containing JSON files.
    Returns:
        dict: Dictionary with filenames as keys and extracted metrics as values.
    """
    metrics = {}
    for system_dir in directory.iterdir():
        assert system_dir.is_dir()

        for chunk_output in system_dir.iterdir():
                with chunk_output.open() as f:
                    data = json.load(f)
                metrics[f"{system_dir.name}/${chunk_output.name}"] = flatten_data(data)

    return metrics

def dataframe_to_markdown(df: pd.DataFrame) -> str:
    markdown_lines = []

    # Header (get column names and format them)
    header = '\n| ' + ' | '.join(df.columns) + ' |'
    markdown_lines.append(header)
    markdown_lines.append("| - " * (len(df.columns)) + "|")  # Separator line

    # Iterate over rows to build Markdown rows
    for _, row in df.iterrows():
        # TODO: define threshold for highlighting
        highlight = False

        fmt = lambda x: f"**{x}**" if highlight else f"{x}"

        # Check for no change and NaN in p_value/t_stat
        row_values = []
        for val in row:
            if isinstance(val, float) and np.isnan(val):  # For NaN values in p-value or t-stat
                row_values.append("-")  # Custom symbol for NaN
            elif isinstance(val, float) and val == 0:  # For no change (mean_diff == 0)
                row_values.append("-")  # Custom symbol for no change
            else:
                row_values.append(fmt(f"{val:.4f}" if isinstance(val, float) else str(val)))

        markdown_lines.append('| ' + ' | '.join(row_values) + ' |')

    return '\n'.join(markdown_lines)


def perform_pairwise_tests(before_metrics: dict, after_metrics: dict) -> pd.DataFrame:
    common_files = sorted(set(before_metrics) & set(after_metrics))
    all_keys = sorted({ metric_keys for file_metrics in before_metrics.values() for metric_keys in file_metrics.keys() })

    results = []

    for key in all_keys:
        before_vals, after_vals = [], []

        for fname in common_files:
            if key in before_metrics[fname] and key in after_metrics[fname]:
                before_vals.append(before_metrics[fname][key])
                after_vals.append(after_metrics[fname][key])

        if len(before_vals) >= 2:
            before_arr = np.array(before_vals)
            after_arr = np.array(after_vals)

            diff = after_arr - before_arr
            pct_change = 100 * diff / before_arr
            t_stat, p_val = ttest_rel(after_arr, before_arr)

            results.append({
                "metric": key,
                "mean_before": np.mean(before_arr),
                "mean_after": np.mean(after_arr),
                "mean_diff": np.mean(diff),
                "mean_%_change": np.mean(pct_change),
                "p_value": p_val,
                "t_stat": t_stat
            })

    df = pd.DataFrame(results).sort_values("p_value")
    return df


if __name__ == "__main__":
    before_dir = os.environ.get("BEFORE_DIR")
    after_dir = os.environ.get("AFTER_DIR")

    if not before_dir or not after_dir:
        print("Error: Environment variables 'BEFORE_DIR' and 'AFTER_DIR' must be set.")
        exit(1)

    before_stats = Path(before_dir) / "stats"
    after_stats = Path(after_dir) / "stats"

    # This may happen if the pull request target does not include PR#399720 yet.
    if not before_stats.exists():
        print("⚠️  Skipping comparison: stats directory is missing in the target commit.")
        exit(0)

    # This should never happen, but we're exiting gracefully anyways
    if not after_stats.exists():
        print("⚠️  Skipping comparison: stats directory missing in current PR evaluation.")
        exit(0)

    before_metrics = load_all_metrics(before_stats)
    after_metrics = load_all_metrics(after_stats)
    df1 = perform_pairwise_tests(before_metrics, after_metrics)
    markdown_table = dataframe_to_markdown(df1)
    print(markdown_table)
