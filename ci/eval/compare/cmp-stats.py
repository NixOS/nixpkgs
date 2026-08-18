import argparse
import json
import numpy as np
import os
import pandas as pd

from dataclasses import asdict, dataclass
from pathlib import Path
from scipy.stats import ttest_rel
from tabulate import tabulate
from typing import Final


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

    See https://github.com/NixOS/nix/blob/187520ce88c47e2859064704f9320a2d6c97e56e/src/libexpr/eval.cc#L2846
    for the ultimate source of this data.

    Args:
        json_data (dict): JSON data containing metrics.
    Returns:
        dict: Flattened metrics with keys as metric names.
    """
    flat_metrics = {}
    for key, value in json_data.items():
        # This key is duplicated as `time.cpu`; we keep that copy.
        if key == "cpuTime":
            continue

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


def metric_table_name(name: str, explain: bool) -> str:
    """
    Returns the name of the metric, plus a footnote to explain it if needed.
    """
    return f"{name}[^{name}]" if explain else name


METRIC_EXPLANATION_FOOTNOTE: Final[str] = """

[^time.cpu]: Number of seconds of CPU time accounted by the OS to the Nix evaluator process. On UNIX systems, this comes from [`getrusage(RUSAGE_SELF)`](https://man7.org/linux/man-pages/man2/getrusage.2.html).
[^time.gc]: Number of seconds of CPU time accounted by the Boehm garbage collector to performing GC.
[^time.gcFraction]: What fraction of the total CPU time is accounted towards performing GC.
[^gc.cycles]: Number of times garbage collection has been performed.
[^gc.heapSize]: Size in bytes of the garbage collector heap.
[^gc.totalBytes]: Size in bytes of all allocations in the garbage collector.
[^envs.bytes]: Size in bytes of all `Env` objects allocated by the Nix evaluator. These are almost exclusively created by [`nix-env`](https://nix.dev/manual/nix/stable/command-ref/nix-env.html).
[^list.bytes]: Size in bytes of all [lists](https://nix.dev/manual/nix/stable/language/syntax.html#list-literal) allocated by the Nix evaluator.
[^sets.bytes]: Size in bytes of all [attrsets](https://nix.dev/manual/nix/stable/language/syntax.html#list-literal) allocated by the Nix evaluator.
[^symbols.bytes]: Size in bytes of all items in the Nix evaluator symbol table.
[^values.bytes]: Size in bytes of all values allocated by the Nix evaluator.
[^envs.number]: The count of all `Env` objects allocated.
[^nrAvoided]: The number of thunks avoided being created.
[^nrExprs]: The number of expression objects ever created.
[^nrFunctionCalls]: The number of function calls ever made.
[^nrLookups]: The number of lookups into an attrset ever made.
[^nrOpUpdateValuesCopied]: The number of attrset values copied in the process of merging attrsets.
[^nrOpUpdates]: The number of attrsets merge operations (`//`) performed.
[^nrPrimOpCalls]: The number of function calls to primops (Nix builtins) ever made.
[^nrThunks]: The number of [thunks](https://nix.dev/manual/nix/latest/language/evaluation.html#laziness) ever made. A thunk is a delayed computation, represented by an expression reference and a closure.
[^sets.number]: The number of attrsets ever made.
[^symbols.number]: The number of symbols ever added to the symbol table.
[^values.number]: The number of values ever made.
[^envs.elements]: The number of values contained within an `Env` object.
[^list.concats]: The number of list concatenation operations (`++`) performed.
[^list.elements]: The number of values contained within a list.
[^sets.elements]: The number of values contained within an attrset.
[^sizes.Attr]: Size in bytes of the `Attr` type.
[^sizes.Bindings]: Size in bytes of the `Bindings` type.
[^sizes.Env]: Size in bytes of the `Env` type.
[^sizes.Value]: Size in bytes of the `Value` type.
"""


@dataclass(frozen=True)
class PairwiseTestResults:
    updated: pd.DataFrame
    equivalent: pd.DataFrame

    @staticmethod
    def tabulate(table, headers) -> str:
        return tabulate(
            table, headers, tablefmt="github", floatfmt=".4f", missingval="-"
        )

    def updated_to_markdown(self, explain: bool) -> str:
        assert not self.updated.empty
        # Header (get column names and format them)
        return self.tabulate(
            headers=[str(column) for column in self.updated.columns],
            table=[
                [
                    # The metric acts as its own footnote name
                    metric_table_name(row["metric"], explain),
                    # Check for no change and NaN in p_value/t_stat
                    *[
                        None if np.isnan(val) or np.allclose(val, 0) else val
                        for val in row[1:]
                    ],
                ]
                for _, row in self.updated.iterrows()
            ],
        )

    def equivalent_to_markdown(self, explain: bool) -> str:
        assert not self.equivalent.empty
        return self.tabulate(
            headers=[str(column) for column in self.equivalent.columns],
            table=[
                [
                    # The metric acts as its own footnote name
                    metric_table_name(row["metric"], explain),
                    row["value"],
                ]
                for _, row in self.equivalent.iterrows()
            ],
        )

    def to_markdown(self, explain: bool) -> str:
        result = ""

        if not self.equivalent.empty:
            result += "## Unchanged values\n\n"
            result += self.equivalent_to_markdown(explain)

        if not self.updated.empty:
            result += ("\n\n" if result else "") + "## Updated values\n\n"
            result += self.updated_to_markdown(explain)

        if explain:
            result += METRIC_EXPLANATION_FOOTNOTE

        return result


@dataclass(frozen=True)
class Equivalent:
    metric: str
    value: float


@dataclass(frozen=True)
class Comparison:
    metric: str
    mean_before: float
    mean_after: float
    mean_diff: float
    mean_pct_change: float


@dataclass(frozen=True)
class ComparisonWithPValue(Comparison):
    p_value: float
    t_stat: float


def metric_sort_key(name: str) -> str:
    if name in ("time.cpu", "time.gc", "time.gcFraction"):
        return (1, name)
    elif name.startswith("gc"):
        return (2, name)
    elif name.endswith(("bytes", "Bytes")):
        return (3, name)
    elif name.startswith("nr") or name.endswith("number"):
        return (4, name)
    else:
        return (5, name)


def perform_pairwise_tests(
    before_metrics: dict, after_metrics: dict
) -> PairwiseTestResults:
    common_files = sorted(set(before_metrics) & set(after_metrics))
    all_keys = sorted(
        {
            metric_keys
            for file_metrics in before_metrics.values()
            for metric_keys in file_metrics.keys()
        },
        key=metric_sort_key,
    )

    updated = []
    equivalent = []

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

        # If there's no difference, add it all to the equivalent output.
        if np.allclose(diff, 0):
            equivalent.append(Equivalent(metric=key, value=before_vals[0]))
        else:
            pct_change = 100 * diff / before_arr

            result = Comparison(
                metric=key,
                mean_before=np.mean(before_arr),
                mean_after=np.mean(after_arr),
                mean_diff=np.mean(diff),
                mean_pct_change=np.mean(pct_change),
            )

            # If there are enough values to perform a t-test, do so.
            if len(before_vals) > 1:
                t_stat, p_val = ttest_rel(after_arr, before_arr)
                result = ComparisonWithPValue(
                    **asdict(result), p_value=p_val, t_stat=t_stat
                )

            updated.append(result)

    return PairwiseTestResults(
        updated=pd.DataFrame(map(asdict, updated)),
        equivalent=pd.DataFrame(map(asdict, equivalent)),
    )


def main():
    parser = argparse.ArgumentParser(
        description="Performance comparison of Nix evaluation statistics"
    )
    parser.add_argument(
        "--explain", action="store_true", help="Explain the evaluation statistics"
    )
    parser.add_argument(
        "before", help="File or directory containing baseline (data before)"
    )
    parser.add_argument(
        "after", help="File or directory containing comparison (data after)"
    )

    options = parser.parse_args()

    before_stats = Path(options.before)
    after_stats = Path(options.after)

    before_metrics = load_all_metrics(before_stats)
    after_metrics = load_all_metrics(after_stats)
    pairwise_test_results = perform_pairwise_tests(before_metrics, after_metrics)
    markdown_table = pairwise_test_results.to_markdown(explain=options.explain)
    print(markdown_table)


if __name__ == "__main__":
    main()
