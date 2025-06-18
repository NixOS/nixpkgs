import argparse
from functools import partial
import json
from multiprocessing import Pool
import os
from pathlib import Path
import subprocess


def dropPrefix(path, nixPrefix):
    return path[len(nixPrefix + "/") :]


def processItem(
    item, nixPrefix, outDir, compression, compressionCommand, compressionExtension
):
    narInfoHash = dropPrefix(item["path"], nixPrefix).split("-")[0]

    narFile = outDir / "nar" / f"{narInfoHash}.nar{compressionExtension}"
    with open(narFile, "wb") as f:
        subprocess.run(
            f"nix-store --dump {item['path']} {compressionCommand}",
            stdout=f,
            shell=True,
            check=True,
        )

    fileHash = (
        subprocess.run(
            ["nix-hash", "--base32", "--type", "sha256", "--flat", narFile],
            capture_output=True,
            check=True,
        )
        .stdout.decode()
        .strip()
    )
    fileSize = os.path.getsize(narFile)

    finalNarFileName = Path("nar") / f"{fileHash}.nar{compressionExtension}"
    os.rename(narFile, outDir / finalNarFileName)

    with open(outDir / f"{narInfoHash}.narinfo", "wt") as f:
        f.write(f"StorePath: {item['path']}\n")
        f.write(f"URL: {finalNarFileName}\n")
        f.write(f"Compression: {compression}\n")
        f.write(f"FileHash: sha256:{fileHash}\n")
        f.write(f"FileSize: {fileSize}\n")
        f.write(f"NarHash: {item['narHash']}\n")
        f.write(f"NarSize: {item['narSize']}\n")
        f.write(
            f"References: {' '.join(dropPrefix(ref, nixPrefix) for ref in item['references'])}\n"
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--compression", choices=["none", "xz", "zstd"])
    args = parser.parse_args()

    compressionCommand = {
        "none": "",
        "xz": "| xz -c",
        "zstd": "| zstd",
    }[args.compression]

    compressionExtension = {
        "none": "",
        "xz": ".xz",
        "zstd": ".zst",
    }[args.compression]

    outDir = Path(os.environ["out"])
    nixPrefix = os.environ["NIX_STORE"]
    numWorkers = int(os.environ.get("NIX_BUILD_CORES", "4"))

    with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
        closures = json.load(f)["closure"]

    os.makedirs(outDir / "nar", exist_ok=True)

    with open(outDir / "nix-cache-info", "w") as f:
        f.write(f"StoreDir: {nixPrefix}\n")

    with Pool(processes=numWorkers) as pool:
        worker = partial(
            processItem,
            nixPrefix=nixPrefix,
            outDir=outDir,
            compression=args.compression,
            compressionCommand=compressionCommand,
            compressionExtension=compressionExtension,
        )
        pool.map(worker, closures)


if __name__ == "__main__":
    main()
