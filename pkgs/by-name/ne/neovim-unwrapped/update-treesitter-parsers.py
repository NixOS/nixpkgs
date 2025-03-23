#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

import re
import subprocess
from pathlib import Path

parsers = {}
dir = Path(__file__).parent
regex = re.compile(r"^TREESITTER_([A-Z_]+)_(URL|SHA256)\s+(.+)$")

src = subprocess.check_output(
    [
        "nix-build",
        dir.parent.parent.parent.parent,
        "-A",
        "neovim-unwrapped.src",
        "--no-out-link",
    ],
    text=True,
).strip()

for line in open(f"{src}/cmake.deps/deps.txt"):
    m = regex.fullmatch(line.strip())
    if m is None:
        continue

    lang = m[1].lower()
    ty = m[2]
    val = m[3]

    if not lang in parsers:
        parsers[lang] = {}
    parsers[lang][ty] = val

with open(dir / "treesitter-parsers.nix", "w") as f:
    f.write("{ fetchurl }:\n\n{\n")
    for lang, src in parsers.items():
        f.write(
            f"""  {lang}.src = fetchurl {{
    url = "{src["URL"]}";
    hash = "sha256:{src["SHA256"]}";
  }};
"""
        )
    f.write("}\n")
