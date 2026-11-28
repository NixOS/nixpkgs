#!/usr/bin/env python3
"""update-script for paper-muncher.

Reads the `project.lock` of the upstream release tarball and regenerates
`sources.json`.

Usage: update.py <new-version>
"""
import json
import subprocess
import sys
import tarfile
import tempfile
import urllib.request
from pathlib import Path

REPO = "odoo/paper-muncher"
CODEBERG = "https://codeberg.org"
THIS_DIR = Path(__file__).parent
SOURCES_JSON = THIS_DIR / "sources.json"


def download(url: str, dest: Path):
    urllib.request.urlretrieve(url, dest)


def nix_hash(args: list[str]) -> str:
    r = subprocess.run(["nix", "hash", *args], capture_output=True, text=True, check=True)
    return r.stdout.strip()


def extract_strip(tarball: Path, tmpdir: Path) -> Path:
    """Extract, stripping the leading path component like `fetchzip`."""
    extract_dir = tmpdir / "extract"
    extract_dir.mkdir()
    with tarfile.open(tarball) as tar:
        tar.extractall(extract_dir, filter="tar")
    entries = [e for e in extract_dir.iterdir() if e.is_dir()]
    assert len(entries) == 1, entries
    return entries[0]


def path_hash(tree_dir: Path) -> str:
    """Hash a normalized tree like `fetchFromCodeberg` (fetchzip)."""
    return nix_hash(["path", "--sri", "--type", "sha256", str(tree_dir)])


def file_hash(tarball: Path) -> str:
    """Hash a raw file like `fetchurl`."""
    return nix_hash(["file", "--sri", "--type", "sha256", str(tarball)])


def codeberg_sri(owner: str, repo: str, rev: str) -> str:
    url = f"{CODEBERG}/{owner}/{repo}/archive/{rev}.tar.gz"
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        tarball = tmp / "extern.tar.gz"
        download(url, tarball)
        tree = extract_strip(tarball, tmp)
        return path_hash(tree)


def main():
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        sys.exit(2)
    version = sys.argv[1].lstrip("v")

    src_url = f"https://github.com/{REPO}/archive/refs/tags/v{version}.tar.gz"

    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        tarball = tmp / "src.tar.gz"
        download(src_url, tarball)
        src_hash = file_hash(tarball)
        src = extract_strip(tarball, tmp)
        lock = json.loads((src / "project.lock").read_text())

    externs = {}
    for ext_id, info in lock["externs"].items():
        assert info["git"].startswith(CODEBERG)
        owner, repo = info["git"][len(CODEBERG) + 1 :].removesuffix(".git").split("/")
        externs[ext_id] = {
            "owner": owner,
            "repo": repo,
            "rev": info["commit"],
            "hash": codeberg_sri(owner, repo, info["commit"]),
        }

    SOURCES_JSON.write_text(
        json.dumps(
            {
                "version": version,
                "src": {"url": src_url, "hash": src_hash},
                "externs": dict(sorted(externs.items())),
            },
            indent=2,
        )
        + "\n"
    )
    print(f"updated to {version}")


if __name__ == "__main__":
    main()
