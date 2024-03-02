#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.click ps.pyyaml ])"
import pathlib

import click

import utils

@click.command
@click.argument(
    "repo-metadata",
    type=click.Path(
        exists=True,
        file_okay=False,
        resolve_path=True,
        path_type=pathlib.Path,
    ),
)
@click.option(
    "--nixpkgs",
    type=click.Path(
        exists=True,
        file_okay=False,
        resolve_path=True,
        writable=True,
        path_type=pathlib.Path,
    ),
    default=pathlib.Path(__file__).parent.parent.parent.parent
)
def main(repo_metadata: pathlib.Path, nixpkgs: pathlib.Path):
    metadata = utils.KDERepoMetadata.from_repo_metadata_checkout(repo_metadata)
    out_dir = nixpkgs / "pkgs/kde/generated"
    metadata.write_json(out_dir)

if __name__ == "__main__":
    main()  # type: ignore
