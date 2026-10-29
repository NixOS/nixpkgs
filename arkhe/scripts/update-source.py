#!/usr/bin/env python3
"""Refresh source/ from an Arkhe workspace and rewrite source-manifest.json.

Usage: update-source.py WORKSPACE [EXTRA_PATH ...]

Every file already listed in source-manifest.json is copied again from
WORKSPACE (a missing file aborts: the snapshot never silently loses a file).
EXTRA_PATH entries (files or directories, relative to WORKSPACE) are added.
Build output and editor/VCS directories are never copied.
"""
import hashlib
import json
import shutil
import sys
from pathlib import Path

SKIP_DIRS = {"target", "node_modules", ".git", ".venv", "venv", "__pycache__", ".direnv"}

root = Path(__file__).resolve().parents[1]
source = root / "source"
manifest_path = root / "source-manifest.json"


def files_under(base: Path, rel: str):
    p = base / rel
    if p.is_file():
        yield rel
    elif p.is_dir():
        for f in sorted(p.rglob("*")):
            parts = f.relative_to(base).parts
            if f.is_file() and not SKIP_DIRS.intersection(parts):
                yield f.relative_to(base).as_posix()
    else:
        raise SystemExit(f"not found in workspace: {rel}")


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    workspace = Path(sys.argv[1]).resolve()
    manifest = json.loads(manifest_path.read_text())
    wanted = set(manifest["files"])
    for extra in sys.argv[2:]:
        wanted.update(files_under(workspace, extra))

    files = {}
    for rel in sorted(wanted):
        src = workspace / rel
        dst = source / rel
        if not src.is_file():
            # README.snapshot.md exists only in the snapshot.
            if rel != "README.snapshot.md" or not dst.is_file():
                raise SystemExit(f"missing in workspace: {rel}")
        else:
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(src, dst)
        files[rel] = hashlib.sha256(dst.read_bytes()).hexdigest()

    manifest["files"] = files
    manifest_path.write_bytes((json.dumps(manifest, indent=2, ensure_ascii=False) + "\n").encode())
    print(f"Snapshot: {len(files)} files")


if __name__ == "__main__":
    main()
