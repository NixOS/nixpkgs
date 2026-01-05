#!/usr/bin/env python

"""Amend systemd-repart definiton files.

In order to avoid Import-From-Derivation (IFD) when building images with
systemd-repart, the definition files created by Nix need to be amended with the
store paths from the closure.

This is achieved by adding CopyFiles= instructions to the definition files.

The arbitrary files configured via `contents` are also added to the definition
files using the same mechanism.
"""

import json
import sys
import shutil
from pathlib import Path


def add_contents_to_definition(
    definition: Path, contents: dict[str, dict[str, str]] | None
) -> None:
    """Add CopyFiles= instructions to a definition for all files in contents."""
    if not contents:
        return

    copy_files_lines: list[str] = []
    for target, options in contents.items():
        source = options["source"]

        copy_files_lines.append(f"CopyFiles={source}:{target}\n")

    with open(definition, "a") as f:
        f.writelines(copy_files_lines)


def add_closure_to_definition(
    definition: Path, closure: Path | None, nix_store_prefix: str | None
) -> None:
    """Add CopyFiles= instructions to a definition for all paths in the closure.

    Replace `/nix/store` with the value of nix_store_prefix.
    """
    if not closure:
        return

    copy_files_lines: list[str] = []
    with open(closure, "r") as f:
        for line in f:
            if not isinstance(line, str):
                continue

            source = Path(line.strip())
            option = f"CopyFiles={source}"
            if nix_store_prefix:
                target = nix_store_prefix / source.relative_to("/nix/store/")
                option = f"{option}:{target}"

            copy_files_lines.append(f"{option}\n")

    with open(definition, "a") as f:
        f.writelines(copy_files_lines)


def main() -> None:
    """Amend the provided repart definitions by adding CopyFiles= instructions.

    For each file specified in the `contents` field of a partition in the
    partiton config file, a `CopyFiles=` instruction is added to the
    corresponding definition file.

    The same is done for every store path of the `closure` field.

    Print the path to a directory that contains the amended repart
    definitions to stdout.
    """
    partition_config_file = sys.argv[1]
    if not partition_config_file:
        print("No partition config file was supplied.")
        sys.exit(1)

    repart_definitions = sys.argv[2]
    if not repart_definitions:
        print("No repart definitions were supplied.")
        sys.exit(1)

    with open(partition_config_file, "rb") as f:
        partition_config = json.load(f)

    if not partition_config:
        print("Partition config is empty.")
        sys.exit(1)

    target_dir = Path("amended-repart.d")
    target_dir.mkdir()
    shutil.copytree(repart_definitions, target_dir, dirs_exist_ok=True)

    for name, config in partition_config.items():
        definition = target_dir.joinpath(f"{name}.conf")
        definition.chmod(0o644)

        contents = config.get("contents")
        add_contents_to_definition(definition, contents)

        closure = config.get("closure")
        nix_store_prefix = config.get("nixStorePrefix")
        add_closure_to_definition(definition, closure, nix_store_prefix)

    print(target_dir.absolute())


if __name__ == "__main__":
    main()
