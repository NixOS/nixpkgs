#!/usr/bin/env python3

import json
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

from common import eprint, load_toml, get_lockfile_version, parse_git_source


def get_manifest_metadata(manifest_path: Path) -> dict[str, Any]:
    cmd = ["cargo", "metadata", "--format-version", "1", "--no-deps", "--manifest-path", str(manifest_path)]
    output = subprocess.check_output(cmd)
    return json.loads(output)


def try_get_crate_manifest_path_from_mainfest_path(manifest_path: Path, crate_name: str) -> Path | None:
    metadata = get_manifest_metadata(manifest_path)

    for pkg in metadata["packages"]:
        if pkg["name"] == crate_name:
            return Path(pkg["manifest_path"])

    return None


def find_crate_manifest_in_tree(tree: Path, crate_name: str) -> Path:
    # in some cases Cargo.toml is not located at the top level, so we also look at subdirectories
    manifest_paths = tree.glob("**/Cargo.toml")

    for manifest_path in manifest_paths:
        res = try_get_crate_manifest_path_from_mainfest_path(manifest_path, crate_name)
        if res is not None:
            return res

    raise Exception(f"Couldn't find manifest for crate {crate_name} inside {tree}.")


def copy_and_patch_git_crate_subtree(git_tree: Path, crate_name: str, crate_out_dir: Path) -> None:
    crate_manifest_path = find_crate_manifest_in_tree(git_tree, crate_name)
    crate_tree = crate_manifest_path.parent

    eprint(f"Copying to {crate_out_dir}")
    shutil.copytree(crate_tree, crate_out_dir)
    crate_out_dir.chmod(0o755)

    with open(crate_manifest_path, "r") as f:
        manifest_data = f.read()

    if "workspace" in manifest_data:
        crate_manifest_metadata = get_manifest_metadata(crate_manifest_path)
        workspace_root = Path(crate_manifest_metadata["workspace_root"])

        root_manifest_path = workspace_root / "Cargo.toml"
        manifest_path = crate_out_dir / "Cargo.toml"

        manifest_path.chmod(0o644)
        eprint(f"Patching {manifest_path}")

        cmd = ["replace-workspace-values", str(manifest_path), str(root_manifest_path)]
        subprocess.check_output(cmd)


def extract_crate_tarball_contents(tarball_path: Path, crate_out_dir: Path) -> None:
    eprint(f"Unpacking to {crate_out_dir}")
    crate_out_dir.mkdir()
    cmd = ["tar", "xf", str(tarball_path), "-C", str(crate_out_dir), "--strip-components=1"]
    subprocess.check_output(cmd)


def create_vendor(vendor_staging_dir: Path, out_dir: Path) -> None:
    lockfile_path = vendor_staging_dir / "Cargo.lock"
    out_dir.mkdir(exist_ok=True)
    shutil.copy(lockfile_path, out_dir / "Cargo.lock")

    cargo_lock_toml = load_toml(lockfile_path)
    lockfile_version = get_lockfile_version(cargo_lock_toml)

    config_lines = [
        '[source.vendored-sources]',
        'directory = "@vendor@"',
        '[source.crates-io]',
        'replace-with = "vendored-sources"',
    ]

    seen_source_keys = set()
    for pkg in cargo_lock_toml["package"]:

        # ignore local dependenices
        if "source" not in pkg.keys():
            continue

        source: str = pkg["source"]

        dir_name = f"{pkg["name"]}-{pkg["version"]}"
        crate_out_dir = out_dir / dir_name

        if source.startswith("git+"):

            source_info = parse_git_source(pkg["source"], lockfile_version)

            git_sha_rev = source_info["git_sha_rev"]
            git_tree = vendor_staging_dir / "git" / git_sha_rev

            copy_and_patch_git_crate_subtree(git_tree, pkg["name"], crate_out_dir)

            # git based crates allow having no checksum information
            with open(crate_out_dir / ".cargo-checksum.json", "w") as f:
                json.dump({"files": {}}, f)

            source_key = source[0:source.find("#")]

            if source_key in seen_source_keys:
                continue

            seen_source_keys.add(source_key)

            config_lines.append(f'[source."{source_key}"]')
            config_lines.append(f'git = "{source_info["url"]}"')
            if source_info["type"] is not None:
                config_lines.append(f'{source_info["type"]} = "{source_info["value"]}"')
            config_lines.append('replace-with = "vendored-sources"')

        elif source.startswith("registry+"):

            filename = f"{pkg["name"]}-{pkg["version"]}.tar.gz"
            tarball_path = vendor_staging_dir / "tarballs" / filename

            extract_crate_tarball_contents(tarball_path, crate_out_dir)

            # non-git based crates need the package checksum at minimum
            with open(crate_out_dir / ".cargo-checksum.json", "w") as f:
                json.dump({"files": {}, "package": pkg["checksum"]}, f)

        else:
            raise Exception(f"Can't process source: {source}.")

    (out_dir / ".cargo").mkdir()
    with open(out_dir / ".cargo" / "config.toml", "w") as config_file:
        config_file.writelines(line + "\n" for line in config_lines)


def main() -> None:
    create_vendor(vendor_staging_dir=Path(sys.argv[1]), out_dir=Path(sys.argv[2]))

if __name__ == "__main__":
    main()
