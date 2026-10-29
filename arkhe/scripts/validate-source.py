#!/usr/bin/env python3
"""Verify the complete distributed source snapshot against its SHA-256 manifest."""
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = root / "source"
expected = json.loads((root / "source-manifest.json").read_text())["files"]
actual = {
    p.relative_to(source).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
    for p in source.rglob("*") if p.is_file()
}
if actual != expected:
    raise SystemExit("Source snapshot differs from source-manifest.json")
print(f"Verified {len(actual)} source files")
