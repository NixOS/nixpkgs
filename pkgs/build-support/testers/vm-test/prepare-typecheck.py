#!/usr/bin/env python3
"""Prepare an image test script for type checking and linting."""

import argparse
import pathlib
import sys


def wrap(source: str) -> tuple[str, int]:
    """Return the source as an async function body and the line offset."""
    lines = source.splitlines(keepends=True)
    body = "".join(f"    {line}" if line.strip() else line for line in lines)
    wrapped = f"async def __image_test__() -> None:\n{body}"
    return wrapped, 1


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("prepend", type=pathlib.Path)
    parser.add_argument("script", type=pathlib.Path)
    parser.add_argument("output", type=pathlib.Path)
    args = parser.parse_args()

    prelude = args.prepend.read_text()
    wrapped, offset = wrap(args.script.read_text())
    args.output.write_text(prelude + "\n" + wrapped)

    prelude_lines = prelude.count("\n") + 1
    total_offset = prelude_lines + offset
    sys.stderr.write(
        f"Type checking the test script; reported line numbers are offset by "
        f"{total_offset} (the stub header). Subtract {total_offset} to get the "
        f"line in the test script.\n"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
