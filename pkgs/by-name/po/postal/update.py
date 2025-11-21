#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ requests click click-log])" bundix bundler nix-update
from __future__ import annotations

import logging
import os
import subprocess
from pathlib import Path

import click
import click_log
import requests

logger = logging.getLogger(__name__)


class PostalRepo:
    def __init__(self, owner: str = "postalserver", repo: str = "postal"):
        self.owner = owner
        self.repo = repo

    @property
    def latest_tag(self) -> str:
        r = requests.get(
            f"https://api.github.com/repos/{self.owner}/{self.repo}/releases/latest",
            headers=self.__get_headers()
        ).json()
        return r["tag_name"]

    def get_file(self, filepath, rev):
        """Return file contents at a given rev.

        :param str filepath: the path to the file, relative to the repo root
        :param str rev: the rev to fetch at :return:

        """
        r = requests.get(
            f"https://raw.githubusercontent.com/{self.owner}/{self.repo}/{rev}/{filepath}",
            headers=self.__get_headers()
        )
        r.raise_for_status()
        return r.text

    def __get_headers(self) -> dict:
        headers = {}
        token = os.getenv("GITHUB_TOKEN")

        if token is not None:
            headers["Authorization"] = "Bearer {}".format(token)

def _call_nix_update(pkg, version):
    """Call nix-update from nixpkgs root dir."""
    nixpkgs_path = Path(__file__).parent / "../../../../"
    return subprocess.check_output(
        ["nix-update", pkg, "--version", version], cwd=nixpkgs_path
    )


@click_log.simple_verbosity_option(logger)
@click.group()
def cli():
    pass


@cli.command()
@click.argument("rev", default="latest")
def update(rev):
    """Update gem files and version.

    REV: the git rev to update to ('X.Y.Z') or
    'latest'; defaults to 'latest'.

    """
    repo = PostalRepo()

    if rev == "latest":
        version = repo.latest_tag
    else:
        version = rev

    logger.debug(f"Using tag {version}")

    rubyenv_dir = Path(__file__).parent / "rubyEnv"

    for fn in ["Gemfile"]:
        with open(rubyenv_dir / fn, "w") as f:
            f.write(repo.get_file(fn, version))

    # # work around https://github.com/nix-community/bundix/issues/8
    subprocess.check_output(["rm", "Gemfile.lock", "gemset.nix"], cwd=rubyenv_dir)
    os.environ["BUNDLE_FORCE_RUBY_PLATFORM"] = "true"
    subprocess.check_output(["bundle", "lock"], cwd=rubyenv_dir)
    subprocess.check_output(["bundix"], cwd=rubyenv_dir)

    _call_nix_update("postal", version)


if __name__ == "__main__":
    cli()
