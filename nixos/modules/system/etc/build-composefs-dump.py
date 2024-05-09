#!/usr/bin/env python3

"""Build a composefs dump from a Json config

See the man page of composefs-dump for details about the format:
https://github.com/containers/composefs/blob/main/man/composefs-dump.md

Ensure to check the file with the check script when you make changes to it:

./check-build-composefs-dump.sh ./build-composefs_dump.py
"""

import glob
import json
import os
import sys
from enum import Enum
from pathlib import Path
from typing import Any

Attrs = dict[str, Any]


class FileType(Enum):
    """The filetype as defined by the `st_mode` stat field in octal

    You can check the st_mode stat field of a path in Python with
    `oct(os.stat("/path/").st_mode)`
    """

    directory = "4"
    file = "10"
    symlink = "12"


class ComposefsPath:
    path: str
    size: int
    filetype: FileType
    mode: str
    uid: str
    gid: str
    payload: str
    rdev: str = "0"
    nlink: int = 1
    mtime: str = "1.0"
    content: str = "-"
    digest: str = "-"

    def __init__(
        self,
        attrs: Attrs,
        size: int,
        filetype: FileType,
        mode: str,
        payload: str,
        path: str | None = None,
    ):
        if path is None:
            path = attrs["target"]
        self.path = path
        self.size = size
        self.filetype = filetype
        self.mode = mode
        self.uid = attrs["uid"]
        self.gid = attrs["gid"]
        self.payload = payload

    def write_line(self) -> str:
        line_list = [
            str(self.path),
            str(self.size),
            f"{self.filetype.value}{self.mode}",
            str(self.nlink),
            str(self.uid),
            str(self.gid),
            str(self.rdev),
            str(self.mtime),
            str(self.payload),
            str(self.content),
            str(self.digest),
        ]
        return " ".join(line_list)


def eprint(*args: Any, **kwargs: Any) -> None:
    print(*args, **kwargs, file=sys.stderr)


def normalize_path(path: str) -> str:
    return str("/" + os.path.normpath(path).lstrip("/"))


def leading_directories(path: str) -> list[str]:
    """Return the leading directories of path

    Given the path "alsa/conf.d/50-pipewire.conf", for example, this function
    returns `[ "alsa", "alsa/conf.d" ]`.
    """
    parents = list(Path(path).parents)
    parents.reverse()
    # remove the implicit `.` from the start of a relative path or `/` from an
    # absolute path
    del parents[0]
    return [str(i) for i in parents]


def add_leading_directories(
    target: str, attrs: Attrs, paths: dict[str, ComposefsPath]
) -> None:
    """Add the leading directories of a target path to the composefs paths

    mkcomposefs expects that all leading directories are explicitly listed in
    the dump file. Given the path "alsa/conf.d/50-pipewire.conf", for example,
    this function adds "alsa" and "alsa/conf.d" to the composefs paths.
    """
    path_components = leading_directories(target)
    for component in path_components:
        composefs_path = ComposefsPath(
            attrs,
            path=component,
            size=4096,
            filetype=FileType.directory,
            mode="0755",
            payload="-",
        )
        paths[component] = composefs_path


def main() -> None:
    """Build a composefs dump from a Json config

    This config describes the files that the final composefs image is supposed
    to contain.
    """
    config_file = sys.argv[1]
    if not config_file:
        eprint("No config file was supplied.")
        sys.exit(1)

    with open(config_file, "rb") as f:
        config = json.load(f)

    if not config:
        eprint("Config is empty.")
        sys.exit(1)

    eprint("Building composefs dump...")

    paths: dict[str, ComposefsPath] = {}
    for attrs in config:
        # Normalize the target path to work around issues in how targets are
        # declared in `environment.etc`.
        attrs["target"] = normalize_path(attrs["target"])

        target = attrs["target"]
        source = attrs["source"]
        mode = attrs["mode"]

        if "*" in source:  # Path with globbing
            glob_sources = glob.glob(source)
            for glob_source in glob_sources:
                basename = os.path.basename(glob_source)
                glob_target = f"{target}/{basename}"

                composefs_path = ComposefsPath(
                    attrs,
                    path=glob_target,
                    size=100,
                    filetype=FileType.symlink,
                    mode="0777",
                    payload=glob_source,
                )

                paths[glob_target] = composefs_path
                add_leading_directories(glob_target, attrs, paths)
        else:  # Without globbing
            if mode == "symlink":
                composefs_path = ComposefsPath(
                    attrs,
                    # A high approximation of the size of a symlink
                    size=100,
                    filetype=FileType.symlink,
                    mode="0777",
                    payload=source,
                )
            else:
                if os.path.isdir(source):
                    composefs_path = ComposefsPath(
                        attrs,
                        size=4096,
                        filetype=FileType.directory,
                        mode=mode,
                        payload=source,
                    )
                else:
                    composefs_path = ComposefsPath(
                        attrs,
                        size=os.stat(source).st_size,
                        filetype=FileType.file,
                        mode=mode,
                        # payload needs to be relative path in this case
                        payload=target.lstrip("/"),
                    )
            paths[target] = composefs_path
            add_leading_directories(target, attrs, paths)

    composefs_dump = ["/ 4096 40755 1 0 0 0 0.0 - - -"]  # Root directory
    for key in sorted(paths):
        composefs_path = paths[key]
        eprint(composefs_path.path)
        composefs_dump.append(composefs_path.write_line())

    print("\n".join(composefs_dump))


if __name__ == "__main__":
    main()
