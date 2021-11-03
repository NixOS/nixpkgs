#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 bash nixpkgs-fmt nixfmt

import subprocess
import json
import shlex
import multiprocessing
from pathlib import Path
from collections import defaultdict
import re

# Nix expression to get all packages and their files
GET_PACKAGES_WITH_FILE = """
with import ./. { allowAliases = false; };
lib.mapAttrs (pname: value:
  let val = builtins.tryEval (value.meta.position or null);
  in if val.success && val.value != null then val.value else null) pkgs
"""


def get_packages():
    COMMAND = [
        *shlex.split("nix-instantiate --eval --strict --json -E"),
        GET_PACKAGES_WITH_FILE,
    ]
    nix_output = subprocess.check_output(COMMAND)
    out = json.loads(nix_output)
    for pname, path in out.items():
        if path is None:
            continue
        path, lineNo = path.rsplit(":", 1)
        path = Path(path)
        yield pname, path


def get_unique_files():
    files = defaultdict(list)
    for p, f in get_packages():
        files[f].append(p)
    for f, p in files.items():
        if len(p) == 1:
            (p,) = p
        else:
            continue
        yield p, f


def get_formatter(path):
    for formatter in ["nixpkgs-fmt", "nixfmt"]:
        try:
            subprocess.check_call([formatter, "--check", path])
        except subprocess.CalledProcessError:
            continue

        # pass formatter here to work around some loop weirdness in python.
        return lambda path, formatter=formatter: subprocess.check_call(
            [formatter, path]
        )

    raise Exception("No formatter determined")


def try_add_test(pname, path):
    print(pname, path)
    old_content = content = path.read_text()
    if content.count("meta =") != 1:
        return
    try:
        formatter = get_formatter(path)
    except Exception:
        return

    content = re.sub(
        r"{(.*?)(, *)?}:",
        lambda m: f"{{{m[1]}, {pname}, testVersion}}:",
        content,
        flags=re.MULTILINE | re.DOTALL,
    )
    if content == old_content:
        return
    content = content.replace(
        "meta =",
        f"passthru.tests.version = testVersion {{ package = {pname}; }};\n\nmeta =",
    )
    path.write_text(content)

    try:
        formatter(path)
        subprocess.check_call(
            shlex.split(
                f"timeout 120 nix-build . -A {pname}.tests.version --arg config '{{ allowAliases = false; }}'"
            )
        )
    except subprocess.CalledProcessError:
        path.write_text(old_content)


def main():
    with multiprocessing.Pool() as pool:
        pool.starmap(try_add_test, get_unique_files())

    get_packages()  # make sure the outputs still cleanly list


if __name__ == "__main__":
    main()
