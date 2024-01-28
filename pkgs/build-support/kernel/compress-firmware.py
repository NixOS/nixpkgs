#!/usr/bin/env python3
import argparse
import lzma
import multiprocessing
import os
import pathlib
import shutil
import typing


def compress_one(source: pathlib.Path, destination: pathlib.Path):
    destination.parent.mkdir(parents=True, exist_ok=True)
    with source.open("rb") as src, lzma.open(
        destination, "wb", check=lzma.CHECK_CRC32, preset=lzma.PRESET_EXTREME
    ) as dst:
        shutil.copyfileobj(src, dst)


def compress_all(items: typing.Iterable[tuple[pathlib.Path, pathlib.Path]]):
    cores = os.getenv("NIX_BUILD_CORES")
    if cores is not None:
        cores = int(cores)
    multiprocessing.Pool(cores).starmap(compress_one, items, chunksize=16)


def main(source: pathlib.Path, destination: pathlib.Path):
    files_to_compress = {}

    for path in source.rglob("*"):
        if path.is_file() and not path.is_symlink():
            out_path = destination / path.relative_to(source)
            out_path = out_path.with_suffix(out_path.suffix + ".xz")
            files_to_compress[path] = out_path

    compress_all(files_to_compress.items())

    for path in source.rglob("*"):
        if path.is_symlink():
            source_path = path.resolve()
            if new_path := files_to_compress.get(source_path):
                target_path = new_path
                need_suffix = True
            else:
                target_path = destination / source_path.relative_to(source)
                need_suffix = False

            out_path = destination / path.relative_to(source)

            if need_suffix:
                out_path = out_path.with_suffix(out_path.suffix + ".xz")

            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.symlink_to(target_path.relative_to(out_path.parent, walk_up=True))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=pathlib.Path, help="Source path")
    parser.add_argument("destination", type=pathlib.Path, help="Destination path")
    args = parser.parse_args()
    source = args.source
    destination = args.destination
    main(source, destination)
