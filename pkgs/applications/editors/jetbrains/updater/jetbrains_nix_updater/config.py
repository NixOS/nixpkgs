import os

import dataclasses
from pathlib import Path

SUPPORTED_SYSTEMS = ["x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin"]


def find_nixpkgs(current_path: Path) -> Path:
    if current_path.joinpath("flake.nix").exists():
        return current_path
    parent = current_path.parent
    if parent == current_path:
        raise Exception("nixpkgs could not be found, please provide --nixpkgs-root")
    return find_nixpkgs(parent)


@dataclasses.dataclass(slots=True)
class UpdaterConfig:
    nixpkgs_root: Path
    jetbrains_root: Path
    ide: str | None  # If None: Run for all IDEs
    old_version: str | None
    no_bin: bool
    no_src: bool
    no_maven_deps: bool

    def __init__(self, argparse_result):
        self.nixpkgs_root = (
            Path(argparse_result.nixpkgs_root)
            if argparse_result.nixpkgs_root is not None
            else find_nixpkgs(Path.cwd())
        )
        self.jetbrains_root = (
            self.nixpkgs_root / "pkgs" / "applications" / "editors" / "jetbrains"
        )
        self.ide = (
            argparse_result.ide
            if argparse_result.ide is not None
            else os.environ.get("UPDATE_NIX_PNAME")
        )
        self.old_version = (
            argparse_result.old_version
            if argparse_result.old_version is not None
            else os.environ.get("UPDATE_NIX_OLD_VERSION")
        )
        self.no_bin = argparse_result.no_bin
        self.no_src = argparse_result.no_src
        self.no_maven_deps = argparse_result.no_maven_deps
