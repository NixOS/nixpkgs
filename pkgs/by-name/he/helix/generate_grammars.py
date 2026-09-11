#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nurl
"""
Generate grammar information for Helix editor by parsing languages.toml
and fetching source information using nurl in parallel.
"""

import argparse
import asyncio
import json
import os
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass
class Grammar:
    name: str
    git_url: str
    rev: str
    subpath: str | None = None


async def run_nurl(url: str, rev: str, semaphore: asyncio.Semaphore) -> dict[str, Any]:
    """Run nurl command for a single grammar and return parsed JSON output."""
    async with semaphore:
        proc = await asyncio.create_subprocess_exec(
            "nurl",
            url,
            rev,
            "--json",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await proc.communicate()

        if proc.returncode != 0:
            raise RuntimeError(f"nurl failed for {url}@{rev}: {stderr.decode()}")

        return json.loads(stdout.decode())


def parse_languages_toml(toml_path: Path) -> list[Grammar]:
    """Parse languages.toml and extract grammar information."""
    with open(toml_path, "rb") as f:
        config = tomllib.load(f)

    grammars = []
    for grammar in config.get("grammar", []):
        if "source" not in grammar:
            continue

        source = grammar["source"]
        if "git" not in source or "rev" not in source:
            continue

        grammars.append(
            Grammar(
                name=grammar["name"].replace("_", "-"),
                git_url=source["git"],
                rev=source["rev"],
                subpath=source.get("subpath"),
            )
        )

    return grammars


async def fetch_all_grammars(
    grammars: list[Grammar], max_parallel: int
) -> dict[str, Any]:
    """Fetch nurl information for all grammars in parallel."""
    semaphore = asyncio.Semaphore(max_parallel)
    results = {}
    total = len(grammars)
    completed = 0

    tasks = []
    for grammar in grammars:
        task = run_nurl(grammar.git_url, grammar.rev, semaphore)
        tasks.append((grammar, task))

    for grammar, task in tasks:
        try:
            result = await task
            results[grammar.name] = {
                "nurl": result,
                "subpath": grammar.subpath,
            }
            completed += 1
            print(f"[{completed}/{total}] ✓ {grammar.name}", file=sys.stderr)
        except Exception as e:
            completed += 1
            print(f"[{completed}/{total}] ✗ {grammar.name}: {e}", file=sys.stderr)
            results[grammar.name] = {"error": str(e)}

    return results


async def main():
    parser = argparse.ArgumentParser(
        description="Generate grammar information for Helix editor"
    )
    parser.add_argument(
        "languages_toml",
        type=Path,
        help="path to languages.toml from Helix repository",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=Path("grammars.json"),
        help="output JSON file (default: grammars.json)",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=os.cpu_count(),
        help=f"number of parallel nurl instances (default: {os.cpu_count()})",
    )

    args = parser.parse_args()

    if not args.languages_toml.exists():
        print(f"Error: {args.languages_toml} not found", file=sys.stderr)
        sys.exit(1)

    print(f"Parsing {args.languages_toml}...", file=sys.stderr)
    grammars = parse_languages_toml(args.languages_toml)
    print(f"Found {len(grammars)} grammars", file=sys.stderr)

    print(f"Fetching grammar information ({args.jobs} parallel jobs)...", file=sys.stderr)
    results = await fetch_all_grammars(grammars, args.jobs)

    errors = [name for name, data in results.items() if "error" in data]
    if errors:
        print(f"\nFailed grammars ({len(errors)}):", file=sys.stderr)
        for name in errors:
            print(f"  - {name}: {results[name]['error']}", file=sys.stderr)
        sys.exit(1)

    with open(args.output, "w") as f:
        json.dump(results, f, indent=2)
        f.write('\n')

    print(f"\nResults written to {args.output}", file=sys.stderr)


if __name__ == "__main__":
    asyncio.run(main())
