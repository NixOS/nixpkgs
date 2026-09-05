#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ python-magic pytablewriter ])"
import json
import pathlib
import re
import subprocess
from dataclasses import dataclass
from collections.abc import Callable
from typing import List, Optional

import magic
import pytablewriter

# Use this file to anchor when Chromium is vendored.
DETECTION_FILE = "v8_context_snapshot.bin"

# User-agent line. Most reliable method of getting the Electron version
ELECTRON_VERSION_DETECT = re.compile(rb"Electron/[0-9]*\.[0-9]*\.[0-9]*")

# Chrome user-agent version regex
CEF_VERSION_DETECT = re.compile(rb"Chrome/[0-9]*\.[0-9]*\.[0-9]*(\.[0-9]*)?")


@dataclass(frozen=True, slots=True)
class FileVisitor:
    """Visitor that takes in file contents, and optionally outputs some relevant data"""

    # Name of the visit to print to stdout
    name: str
    # The actual visitor
    visit: Callable[[bytes], Optional[str]]


@dataclass(frozen=True, slots=True)
class FileData:
    """Data that is output"""

    # The type of file identified
    name: str
    # The data extracted
    data: str


def run(*args) -> Optional[str]:
    """Wrapper around check_output that return None if the process fails"""
    try:
        return subprocess.check_output(args, stderr=subprocess.STDOUT).decode()
    except subprocess.CalledProcessError:
        return None


def get_electron_packages() -> List[str]:
    """List of packages with the detection anchor file within it"""
    output = run("nix-locate", "--minimal", DETECTION_FILE)
    return output.splitlines() if output else []


def build_derivation(attr: str) -> Optional[str]:
    """Builds an attribute, and returns the outpath"""
    output = run("nix", "build", "-f.", "--quiet", "--json", attr)
    return json.loads(output)[0]["outputs"]["out"] if output else None


def get_version(attr: str) -> Optional[str]:
    """Get the version of a package via its attribute"""
    output = run("nix", "eval", "-f.", "--quiet", "--json", attr + ".version")
    return json.loads(output) if output else None


def find_data(
    dir: pathlib.Path,
    filter: Callable[[pathlib.Path], bool],
    visitors: List[FileVisitor],
) -> Optional[FileData]:
    """Find some data in a directory by visiting all the files and returning the first match

    Make sure the visitors are in the correct order of priority that you care about.
    """

    print("Searching for", ", ".join(visitor.name for visitor in visitors))

    for dir, _, filenames in dir.walk():
        for file in filenames:
            real_file = dir / file

            if not filter(real_file):
                continue

            with open(real_file, "rb") as f:
                content = f.read()

            for visitor in visitors:
                output = visitor.visit(content)
                if output:
                    print(f"Found {visitor.name}: {output}")
                    return FileData(visitor.name, output)


def regex_searcher(regex: re.Pattern[bytes]) -> Callable[[bytes], Optional[str]]:
    """Takes in a compiled regex, return a callable for extracting data from bytes"""

    def search(input: bytes) -> Optional[str]:
        needle = regex.search(input)

        if needle:
            return needle.group(0).decode().replace("/", " ")
        else:
            return None

    return search


ELECTRON_VISITOR = FileVisitor("Electron", regex_searcher(ELECTRON_VERSION_DETECT))

CEF_VISITOR = FileVisitor("CEF", regex_searcher(CEF_VERSION_DETECT))


def main():

    # Gather the package metadata we discover
    packages = {}

    items = get_electron_packages()

    print(f"Will be processing: {items}\n")

    # Use libmagic/find to get mime
    find = magic.Magic(mime=True, uncompress=True)

    # Defined within to share the libmagic instance across calls
    def find_elf(path: pathlib.Path) -> bool:
        # Ignore symlinks as they may point to a proper version
        if path.is_symlink():
            return False

        mime = find.from_file(path)

        # Some are detected as sharedlibs. That's fine.
        return "-sharedlib" in mime or "-executable" in mime

    for package in items:
        print(f"Building package: {package}")
        outpath = build_derivation(package)
        if outpath is None:
            # Failed to build, not much we can do.
            continue
        print(f"Built package: {package}, {outpath}")

        data = find_data(
            pathlib.Path(outpath),
            find_elf,
            [
                ELECTRON_VISITOR,
                CEF_VISITOR,
            ],
        )
        print()

        packages[package] = [
            package,
            get_version(package),
            data.name if data else "Unknown",
            data.data if data else "Unknown",
        ]

    table = pytablewriter.MarkdownTableWriter(
        table_name="Vendored Electron/Chromium Packages",
        headers=["attribute", "Version", "Electron/CEF", "CEF/Electron Version"],
        value_matrix=list(packages.values()),
    )

    print(table.write_table())


if __name__ == "__main__":
    main()
