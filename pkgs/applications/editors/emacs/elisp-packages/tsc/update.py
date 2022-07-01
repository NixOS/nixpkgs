#!/usr/bin/env python3
from textwrap import dedent
from os.path import (
    abspath,
    dirname,
    join,
)
from typing import (
    Dict,
    Any,
)
import subprocess
import tempfile
import json
import sys
import re

import requests


def eval_drv(nixpkgs: str, expr: str) -> Any:
    expr = "\n".join(
        (
            "with (import %s {});" % nixpkgs,
            expr,
        )
    )

    with tempfile.NamedTemporaryFile(mode="w") as f:
        f.write(dedent(expr))
        f.flush()
        p = subprocess.run(
            ["nix-instantiate", "--json", f.name], stdout=subprocess.PIPE, check=True
        )

    return p.stdout.decode().strip()


def get_src(tag_name: str) -> Dict[str, str]:
    p = subprocess.run(
        [
            "nix-prefetch-github",
            "--rev",
            tag_name,
            "--json",
            "emacs-tree-sitter",
            "elisp-tree-sitter",
        ],
        stdout=subprocess.PIPE,
        check=True,
    )
    src = json.loads(p.stdout)

    fields = ["owner", "repo", "rev", "sha256"]

    return {f: src[f] for f in fields}


def get_cargo_sha256(drv_path: str):
    # Note: No check=True since we expect this command to fail
    p = subprocess.run(["nix-store", "-r", drv_path], stderr=subprocess.PIPE)

    stderr = p.stderr.decode()
    lines = iter(stderr.split("\n"))

    for l in lines:
        if l.startswith("error: hash mismatch in fixed-output derivation"):
            break
    else:
        raise ValueError("Did not find expected hash mismatch message")

    for l in lines:
        m = re.match(r"\s+got:\s+(.+)$", l)
        if m:
            return m.group(1)

    raise ValueError("Could not extract actual sha256 hash: ", stderr)


if __name__ == "__main__":
    cwd = sys.argv[1]

    nixpkgs = abspath(join(cwd, "../../../../../.."))

    tag_name = requests.get(
        "https://api.github.com/repos/emacs-tree-sitter/elisp-tree-sitter/releases/latest"
    ).json()["tag_name"]

    src = get_src(tag_name)

    with tempfile.NamedTemporaryFile(mode="w") as f:
        json.dump(src, f)
        f.flush()

        drv_path = eval_drv(
            nixpkgs,
            """
        rustPlatform.buildRustPackage {
          pname = "tsc-dyn";
          version = "%s";
          nativeBuildInputs = [ clang ];
          src = fetchFromGitHub (lib.importJSON %s);
          sourceRoot = "source/core";
          cargoSha256 = lib.fakeSha256;
        }
        """
            % (tag_name, f.name),
        )

    cargo_sha256 = get_cargo_sha256(drv_path)

    with open(join(cwd, "src.json"), mode="w") as f:
        json.dump(
            {
                "src": src,
                "version": tag_name,
                "cargoSha256": cargo_sha256,
            },
            f,
            indent=2,
        )
        f.write("\n")
