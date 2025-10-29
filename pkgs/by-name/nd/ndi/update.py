#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.absl-py ps.requests ])"

import hashlib
import io
import json
import os.path
import tarfile

import requests
from absl import app, flags

BASE_NAME = "Install_NDI_SDK_v5_Linux"
NDI_SDK_URL = f"https://downloads.ndi.tv/SDK/NDI_SDK_Linux/{BASE_NAME}.tar.gz"
NDI_EXEC = f"{BASE_NAME}.sh"

NDI_ARCHIVE_MAGIC = b"__NDI_ARCHIVE_BEGIN__\n"

FLAG_out = flags.DEFINE_string("out", None, "Path to read/write version.json from/to.")


def find_version_json() -> str:
    if FLAG_out.value:
        return FLAG_out.value
    try_paths = ["pkgs/development/libraries/ndi/version.json", "version.json"]
    for path in try_paths:
        if os.path.exists(path):
            return path
    raise Exception(
        "Couldn't figure out where to write version.json; try specifying --out"
    )


def fetch_tarball() -> bytes:
    r = requests.get(NDI_SDK_URL)
    r.raise_for_status()
    return r.content


def read_version(tarball: bytes) -> str:
    # Find the inner script.
    outer_tarfile = tarfile.open(fileobj=io.BytesIO(tarball), mode="r:gz")
    eula_script = outer_tarfile.extractfile(NDI_EXEC).read()

    # Now find the archive embedded within the script.
    archive_start = eula_script.find(NDI_ARCHIVE_MAGIC) + len(NDI_ARCHIVE_MAGIC)
    inner_tarfile = tarfile.open(
        fileobj=io.BytesIO(eula_script[archive_start:]), mode="r:gz"
    )

    # Now find Version.txt...
    version_txt = (
        inner_tarfile.extractfile("NDI SDK for Linux/Version.txt")
        .read()
        .decode("utf-8")
    )
    _, _, version = version_txt.strip().partition(" v")
    return version


def main(argv):
    tarball = fetch_tarball()

    sha256 = hashlib.sha256(tarball).hexdigest()
    version = {
        "hash": f"sha256:{sha256}",
        "version": read_version(tarball),
    }

    out_path = find_version_json()
    with open(out_path, "w") as f:
        json.dump(version, f)
        f.write("\n")


if __name__ == "__main__":
    app.run(main)
