#!/usr/bin/env nix-shell
#! nix-shell ../../../../../../. -i python3 -p python3 -p nix
from os.path import (
    dirname,
    abspath,
    join,
)
from typing import (
    List,
    Any,
)
import subprocess
import json
import sys
import os


def fmt_grammar(grammar: str) -> str:
    return "tree-sitter-" + grammar


def eval_expr(nixpkgs: str, expr: str) -> Any:
    p = subprocess.run(
        [
            "nix-instantiate",
            "--json",
            "--eval",
            "--expr",
            ("with import %s {}; %s" % (nixpkgs, expr)),
        ],
        check=True,
        stdout=subprocess.PIPE,
    )
    return json.loads(p.stdout)


def check_grammar_exists(nixpkgs: str, grammar: str) -> bool:
    return eval_expr(
        nixpkgs, f'lib.hasAttr "{fmt_grammar(grammar)}" tree-sitter-grammars'
    )


def build_attr(nixpkgs, attr: str) -> str:
    return (
        subprocess.run(
            ["nix-build", "--no-out-link", nixpkgs, "-A", attr],
            check=True,
            stdout=subprocess.PIPE,
        )
        .stdout.decode()
        .strip()
    )


if __name__ == "__main__":
    cwd = dirname(abspath(__file__))
    nixpkgs = abspath(join(cwd, "../../../../../.."))

    src_dir = build_attr(nixpkgs, "emacs.pkgs.tree-sitter-langs.src")

    existing: List[str] = []

    grammars = os.listdir(join(src_dir, "repos"))
    for g in grammars:
        exists = check_grammar_exists(nixpkgs, g)
        if exists:
            existing.append(fmt_grammar(g))
        else:
            sys.stderr.write("Missing grammar: " + fmt_grammar(g) + "\n")
            sys.stderr.flush()

    with open(join(cwd, "default-grammars.json"), mode="w") as f:
        json.dump(sorted(existing), f, indent=2)
        f.write("\n")
