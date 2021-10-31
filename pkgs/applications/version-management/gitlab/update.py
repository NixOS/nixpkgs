#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i python3 -p bundix bundler nix-update nix nix-universal-prefetch python3 python3Packages.requests python3Packages.click python3Packages.click-log prefetch-yarn-deps

import click
import click_log
import os
import re
import logging
import subprocess
import json
import pathlib
import tempfile
from distutils.version import LooseVersion
from typing import Iterable

import requests

logger = logging.getLogger(__name__)


class GitLabRepo:
    version_regex = re.compile(r"^v\d+\.\d+\.\d+(\-rc\d+)?(\-ee)?")
    def __init__(self, owner: str = 'gitlab-org', repo: str = 'gitlab'):
        self.owner = owner
        self.repo = repo

    @property
    def url(self):
        return f"https://gitlab.com/{self.owner}/{self.repo}"

    @property
    def tags(self) -> Iterable[str]:
        r = requests.get(self.url + "/refs?sort=updated_desc&ref=master").json()
        tags = r.get("Tags", [])

        # filter out versions not matching version_regex
        versions = list(filter(self.version_regex.match, tags))

        # sort, but ignore v and -ee for sorting comparisons
        versions.sort(key=lambda x: LooseVersion(x.replace("v", "").replace("-ee", "")), reverse=True)
        return versions

    def get_git_hash(self, rev: str):
        return subprocess.check_output(['nix-universal-prefetch', 'fetchFromGitLab', '--owner', self.owner, '--repo', self.repo, '--rev', rev]).decode('utf-8').strip()

    def get_yarn_hash(self, rev: str):
        with tempfile.TemporaryDirectory() as tmp_dir:
            with open(tmp_dir + '/yarn.lock', 'w') as f:
                f.write(self.get_file('yarn.lock', rev))
            return subprocess.check_output(['prefetch-yarn-deps', tmp_dir + '/yarn.lock']).decode('utf-8').strip()

    @staticmethod
    def rev2version(tag: str) -> str:
        """
        normalize a tag to a version number.
        This obviously isn't very smart if we don't pass something that looks like a tag
        :param tag: the tag to normalize
        :return: a normalized version number
        """
        # strip v prefix
        version = re.sub(r"^v", '', tag)
        # strip -ee suffix
        return re.sub(r"-ee$", '', version)

    def get_file(self, filepath, rev):
        """
        returns file contents at a given rev
        :param filepath: the path to the file, relative to the repo root
        :param rev: the rev to fetch at
        :return:
        """
        return requests.get(self.url + f"/raw/{rev}/{filepath}").text

    def get_data(self, rev):
        version = self.rev2version(rev)

        passthru = {v: self.get_file(v, rev).strip() for v in ['GITALY_SERVER_VERSION', 'GITLAB_PAGES_VERSION',
                                                               'GITLAB_SHELL_VERSION']}

        passthru["GITLAB_WORKHORSE_VERSION"] = version

        return dict(version=self.rev2version(rev),
                    repo_hash=self.get_git_hash(rev),
                    yarn_hash=self.get_yarn_hash(rev),
                    owner=self.owner,
                    repo=self.repo,
                    rev=rev,
                    passthru=passthru)


def _get_data_json():
    data_file_path = pathlib.Path(__file__).parent / 'data.json'
    with open(data_file_path, 'r') as f:
        return json.load(f)


def _call_nix_update(pkg, version):
    """calls nix-update from nixpkgs root dir"""
    nixpkgs_path = pathlib.Path(__file__).parent / '../../../../'
    return subprocess.check_output(['nix-update', pkg, '--version', version], cwd=nixpkgs_path)


@click_log.simple_verbosity_option(logger)
@click.group()
def cli():
    pass


@cli.command('update-data')
@click.option('--rev', default='latest', help='The rev to use (vX.Y.Z-ee), or \'latest\'')
def update_data(rev: str):
    """Update data.nix"""
    repo = GitLabRepo()

    if rev == 'latest':
        # filter out pre and re releases
        rev = next(filter(lambda x: not ('rc' in x or x.endswith('pre')), repo.tags))
    logger.debug(f"Using rev {rev}")

    version = repo.rev2version(rev)
    logger.debug(f"Using version {version}")

    data_file_path = pathlib.Path(__file__).parent / 'data.json'

    data = repo.get_data(rev)

    with open(data_file_path.as_posix(), 'w') as f:
        json.dump(data, f, indent=2)
        f.write("\n")


@cli.command('update-rubyenv')
def update_rubyenv():
    """Update rubyEnv"""
    repo = GitLabRepo()
    rubyenv_dir = pathlib.Path(__file__).parent / f"rubyEnv"

    # load rev from data.json
    data = _get_data_json()
    rev = data['rev']

    with open(rubyenv_dir / 'Gemfile.lock', 'w') as f:
        f.write(repo.get_file('Gemfile.lock', rev))
    with open(rubyenv_dir / 'Gemfile', 'w') as f:
        original = repo.get_file('Gemfile', rev)
        original += "\ngem 'sd_notify'\n"
        f.write(re.sub(r".*mail-smtp_pool.*", "", original))

    subprocess.check_output(['bundle', 'lock'], cwd=rubyenv_dir)
    subprocess.check_output(['bundix'], cwd=rubyenv_dir)


@cli.command('update-gitaly')
def update_gitaly():
    """Update gitaly"""
    data = _get_data_json()
    gitaly_server_version = data['passthru']['GITALY_SERVER_VERSION']
    repo = GitLabRepo(repo='gitaly')
    gitaly_dir = pathlib.Path(__file__).parent / 'gitaly'

    for fn in ['Gemfile.lock', 'Gemfile']:
        with open(gitaly_dir / fn, 'w') as f:
            f.write(repo.get_file(f"ruby/{fn}", f"v{gitaly_server_version}"))

    subprocess.check_output(['bundle', 'lock'], cwd=gitaly_dir)
    subprocess.check_output(['bundix'], cwd=gitaly_dir)

    _call_nix_update('gitaly', gitaly_server_version)


@cli.command('update-gitlab-shell')
def update_gitlab_shell():
    """Update gitlab-shell"""
    data = _get_data_json()
    gitlab_shell_version = data['passthru']['GITLAB_SHELL_VERSION']
    _call_nix_update('gitlab-shell', gitlab_shell_version)


@cli.command('update-gitlab-workhorse')
def update_gitlab_workhorse():
    """Update gitlab-workhorse"""
    data = _get_data_json()
    gitlab_workhorse_version = data['passthru']['GITLAB_WORKHORSE_VERSION']
    _call_nix_update('gitlab-workhorse', gitlab_workhorse_version)


@cli.command('update-all')
@click.option('--rev', default='latest', help='The rev to use (vX.Y.Z-ee), or \'latest\'')
@click.pass_context
def update_all(ctx, rev: str):
    """Update all gitlab components to the latest stable release"""
    ctx.invoke(update_data, rev=rev)
    ctx.invoke(update_rubyenv)
    ctx.invoke(update_gitaly)
    ctx.invoke(update_gitlab_shell)
    ctx.invoke(update_gitlab_workhorse)


if __name__ == '__main__':
    cli()
