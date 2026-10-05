#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p git nix-prefetch-git nixfmt python3

"""Update the OpenVINO Intel NPU Compiler package.

The compiler and its OpenVINO pin move together: the revision comes from
validation/openvino_config.json at the compiler tag.
"""

import json
import re
import subprocess
import sys
from pathlib import Path

COMPILER_URL = "https://github.com/openvinotoolkit/npu_compiler"
OPENVINO_URL = "https://github.com/openvinotoolkit/openvino"

# npu_ud_<year>_<week>[_<patch>]_rc<N>, e.g. npu_ud_2026_38_rc1 -> 2026.38rc1.
TAG_RE = re.compile(r"npu_ud_(\d+)_(\d+)(?:_(\d+))?_rc(\d+)")

PACKAGE_NIX = "pkgs/by-name/op/openvino-intel-npu-compiler/package.nix"


def run(*cmd: str) -> str:
    return subprocess.run(cmd, check=True, stdout=subprocess.PIPE, text=True).stdout


def tag_version(tag: str) -> str:
    """npu_ud_2026_38_rc1 -> 2026.38rc1 (the patch component is optional)."""
    year, week, patch, rc = TAG_RE.fullmatch(tag).groups()
    return f"{year}.{week}{f'.{patch}' if patch else ''}rc{rc}"


def tag_sort_key(tag: str) -> tuple[int, int, int, int]:
    year, week, patch, rc = TAG_RE.fullmatch(tag).groups()
    return (int(year), int(week), int(patch or 0), int(rc))


def latest_tag() -> tuple[str, str]:
    """Return the newest compiler tag and the commit it points at."""
    commit: dict[str, str] = {}
    for line in run("git", "ls-remote", "--tags", COMPILER_URL).splitlines():
        rev, ref = line.split("\t")
        peeled = ref.endswith("^{}")
        name = ref.removeprefix("refs/tags/").removesuffix("^{}")
        # Annotated tags list the tag object first and the peeled commit after.
        if peeled or name not in commit:
            commit[name] = rev

    candidates = [tag for tag in commit if TAG_RE.fullmatch(tag)]
    if not candidates:
        sys.exit(f"error: no {TAG_RE.pattern} tag found in {COMPILER_URL}")

    tag = max(candidates, key=tag_sort_key)
    return tag, commit[tag]


def prefetch(
    url: str, rev: str, *, lfs: bool = False, submodules: bool = False
) -> dict:
    cmd = ["nix-prefetch-git", "--quiet", "--url", url, "--rev", rev]
    if lfs:
        cmd.append("--fetch-lfs")
    if submodules:
        cmd.append("--fetch-submodules")
    return json.loads(run(*cmd))


def replace_field(
    text: str, block: str, field: str, value: str, comment: str = ""
) -> str:
    """Replace `field = "...";` inside the `block` section of package.nix."""
    start = text.index(block)
    end = text.index("\n  };", start)
    body, count = re.subn(
        rf'^(\s*{field} = )"[^"]*";.*$',
        rf'\g<1>"{value}";{comment}',
        text[start:end],
        count=1,
        flags=re.MULTILINE,
    )
    assert count == 1, f"could not find {field} in {block.strip()}"
    return text[:start] + body + text[end:]


def main() -> None:
    repo = Path(run("git", "rev-parse", "--show-toplevel").strip())
    package = repo / PACKAGE_NIX
    text = package.read_text()

    current = re.search(r'^  version = "(.*)";', text, flags=re.MULTILINE).group(1)
    print(f"Current version: {current}")

    tag, rev = latest_tag()
    version = tag_version(tag)
    print(f"Latest version: {version} ({tag}, {rev})")

    if current == version:
        print(f"openvino-intel-npu-compiler is up to date: {current}")
        return

    src = prefetch(COMPILER_URL, rev, lfs=True, submodules=True)
    openvino_rev = json.loads(
        (Path(src["path"]) / "validation/openvino_config.json").read_text()
    )["openvinotoolkit"]
    print(f"OpenVINO revision: {openvino_rev}")
    openvino = prefetch(OPENVINO_URL, openvino_rev, submodules=True)

    text = re.sub(
        r'^(  version = )"[^"]*";',
        rf'\g<1>"{version}";',
        text,
        count=1,
        flags=re.MULTILINE,
    )
    text = replace_field(text, "  src = fetchFromGitHub {", "tag", tag)
    text = replace_field(text, "  src = fetchFromGitHub {", "hash", src["hash"])
    text = replace_field(text, "  openvinoSrc = fetchFromGitHub {", "rev", openvino_rev)
    text = replace_field(
        text, "  openvinoSrc = fetchFromGitHub {", "hash", openvino["hash"]
    )
    package.write_text(text)

    subprocess.run(["nixfmt", str(package)], check=True)
    print(f"Updated openvino-intel-npu-compiler to {version}")


if __name__ == "__main__":
    main()
