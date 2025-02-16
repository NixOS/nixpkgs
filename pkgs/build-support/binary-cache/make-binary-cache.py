from functools import partial
import json
from multiprocessing import Pool
import os
from pathlib import Path
import subprocess


def dropPrefix(path, nixPrefix):
    return path[len(nixPrefix + "/") :]


def processItem(item, nixPrefix, outDir):
    narInfoHash = dropPrefix(item["path"], nixPrefix).split("-")[0]

    xzFile = outDir / "nar" / f"{narInfoHash}.nar.xz"
    with open(xzFile, "wb") as f:
        subprocess.run(
            f"nix-store --dump {item['path']} | xz -c",
            stdout=f,
            shell=True,
            check=True,
        )

    fileHash = (
        subprocess.run(
            ["nix-hash", "--base32", "--type", "sha256", "--flat", xzFile],
            capture_output=True,
            check=True,
        )
        .stdout.decode()
        .strip()
    )
    fileSize = os.path.getsize(xzFile)

    finalXzFileName = Path("nar") / f"{fileHash}.nar.xz"
    os.rename(xzFile, outDir / finalXzFileName)

    with open(outDir / f"{narInfoHash}.narinfo", "wt") as f:
        f.write(f"StorePath: {item['path']}\n")
        f.write(f"URL: {finalXzFileName}\n")
        f.write("Compression: xz\n")
        f.write(f"FileHash: sha256:{fileHash}\n")
        f.write(f"FileSize: {fileSize}\n")
        f.write(f"NarHash: {item['narHash']}\n")
        f.write(f"NarSize: {item['narSize']}\n")
        f.write(f"References: {' '.join(dropPrefix(ref, nixPrefix) for ref in item['references'])}\n")


def main():
    outDir = Path(os.environ["out"])
    nixPrefix = os.environ["NIX_STORE"]
    numWorkers = int(os.environ.get("NIX_BUILD_CORES", "4"))

    with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
        closures = json.load(f)["closure"]

    os.makedirs(outDir / "nar", exist_ok=True)

    with open(outDir / "nix-cache-info", "w") as f:
        f.write(f"StoreDir: {nixPrefix}\n")

    with Pool(processes=numWorkers) as pool:
        worker = partial(processItem, nixPrefix=nixPrefix, outDir=outDir)
        pool.map(worker, closures)


if __name__ == "__main__":
    main()
