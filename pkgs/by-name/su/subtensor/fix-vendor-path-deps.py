"""Fix intra-workspace path deps in vendored git-source crates.

fetchCargoVendor copies crate dirs from git sources verbatim, without
rewriting intra-workspace path deps the way `cargo vendor` would. Build
tools such as substrate-wasm-builder spawn a fresh cargo with no lock file;
that fresh resolution follows path deps literally and chokes on
monorepo-relative paths that no longer exist in the flattened vendor layout.
"""

import os
import sys
import tomllib
from pathlib import Path

import tomli_w

DEP_TABLES = ("dependencies", "dev-dependencies", "build-dependencies")


def normalize(name):
    return name.replace("_", "-")


def iter_dep_tables(manifest):
    roots = [
        manifest,
        *((manifest.get("target") or {}).values()),
        manifest.get("workspace") or {},
    ]
    for root in roots:
        if not isinstance(root, dict):
            continue
        for tbl in DEP_TABLES:
            t = root.get(tbl)
            if isinstance(t, dict):
                yield t


def build_crate_map(src_dir):
    crate_map = {}
    for d in src_dir.iterdir():
        manifest_path = d / "Cargo.toml"
        if not manifest_path.is_file():
            continue
        with manifest_path.open("rb") as fh:
            manifest = tomllib.load(fh)
        name = manifest.get("package", {}).get("name")
        if name:
            crate_map[normalize(name)] = d
    return crate_map


def fix_manifest(toml_path, crate_map):
    with toml_path.open("rb") as fh:
        manifest = tomllib.load(fh)

    crate_dir = toml_path.parent
    changed = False
    for table in iter_dep_tables(manifest):
        for alias, spec in table.items():
            if not isinstance(spec, dict):
                continue
            path = spec.get("path")
            if not path or (crate_dir / path).is_dir():
                continue
            package = spec.get("package", alias)
            target = crate_map.get(normalize(package))
            if target is None:
                # cargo lazily resolves; deps that aren't pulled into the active
                # build (dev-deps of transitive crates, optional/feature-gated,
                # target-conditional, etc.) never get their Cargo.toml loaded,
                # so a dangling path is harmless. Warn so it's visible.
                print(f"{toml_path}: skipping unresolved {package!r} -> {path!r}", file=sys.stderr)
                continue
            new_path = os.path.relpath(target, crate_dir)
            print(f"{toml_path}: {package} {path!r} -> {new_path!r}", file=sys.stderr)
            spec["path"] = new_path
            changed = True

    if changed:
        with toml_path.open("wb") as fh:
            tomli_w.dump(manifest, fh)


def main():
    vendor_dir = Path(sys.argv[1])
    for src_dir in sorted(vendor_dir.glob("source-git-*")):
        if not src_dir.is_dir():
            continue
        crate_map = build_crate_map(src_dir)
        for toml_path in sorted(src_dir.glob("*/Cargo.toml")):
            fix_manifest(toml_path, crate_map)


if __name__ == "__main__":
    main()
