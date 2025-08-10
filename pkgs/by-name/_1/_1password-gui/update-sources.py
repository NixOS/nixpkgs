#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 gnupg
import json
import os
import shutil
import subprocess
import sys
import tempfile
from collections import OrderedDict

DOWNLOADS_BASE_URL = "https://downloads.1password.com"
OP_PGP_KEYID = "3FEF9748469ADBE15DA7CA80AC2D62742012EA22"


class Sources(OrderedDict):
    def __init__(self):
        with open("sources.json", "r") as fp:
            self.update(json.load(fp))

    def persist(self):
        with open("sources.json", "w") as fp:
            print(json.dumps(self, indent=2), file=fp)

class GPG:
    def __new__(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        if hasattr(self, "gnupghome"):
            return

        self.gpg = shutil.which("gpg")
        self.gpgv = shutil.which("gpgv")
        self.gnupghome = tempfile.mkdtemp(prefix="1password-gui-gnupghome.")
        self.env = {"GNUPGHOME": self.gnupghome}
        self._run(
            self.gpg,
            "--no-default-keyring",
            "--keyring",
            "trustedkeys.kbx",
            "--keyserver",
            "keyserver.ubuntu.com",
            "--receive-keys",
            OP_PGP_KEYID,
        )

    def __del__(self):
        shutil.rmtree(self.gnupghome)

    def _run(self, *args):
        try:
            subprocess.run(args, env=self.env, check=True, capture_output=True)
        except subprocess.CalledProcessError as cpe:
            print(cpe.stderr, file=sys.stderr)
            raise SystemExit(f"gpg error: {cpe.cmd}")

    def verify(self, sigfile, datafile):
        return self._run(self.gpgv, sigfile, datafile)


def nix_store_prefetch(url):
    nix = shutil.which("nix")
    cp = subprocess.run(
        [nix, "store", "prefetch-file", "--json", url], check=True, capture_output=True
    )
    out = json.loads(cp.stdout)

    return out["storePath"], out["hash"]


def mk_url(channel, os, version, arch):
    if os == "linux":
        arch_alias = {"x86_64": "x64", "aarch64": "arm64"}[arch]
        path = f"linux/tar/{channel}/{arch}/1password-{version}.{arch_alias}.tar.gz"
    elif os == "darwin":
        path = f"mac/1Password-{version}-{arch}.zip"
    else:
        raise SystemExit(f"update-sources.py: unsupported OS {os}")

    return f"{DOWNLOADS_BASE_URL}/{path}"


def download(channel, os, version, arch):
    url = mk_url(channel, os, version, arch)
    store_path_tarball, hash = nix_store_prefetch(url)

    # Linux release tarballs come with detached PGP signatures.
    if os == "linux":
        store_path_sig, _ = nix_store_prefetch(url + ".sig")
        GPG().verify(store_path_sig, store_path_tarball)

    return url, hash


def main(args):
    """Gets called with args in `channel/os/version` format.

    e.g.:
      update-sources.py stable/linux/8.10.80 beta/linux/8.10.82-12.BETA
    """
    sources = Sources()

    for triplet in args[1:]:
        channel, os, version = triplet.split("/")
        release = sources[channel][os]
        if release["version"] == version:
            continue

        release["version"] = version
        for arch in release["sources"]:
            url, hash = download(channel, os, version, arch)
            release["sources"][arch].update({"url": url, "hash": hash})

    sources.persist()


if __name__ == "__main__":
    sys.exit(main(sys.argv))
