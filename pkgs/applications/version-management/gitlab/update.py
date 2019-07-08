#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p bundix common-updater-scripts nix nix-prefetch-git python3 python3Packages.requests python3Packages.lxml python3Packages.click python3Packages.click-log

import click
import click_log
import os
import re
import logging
import subprocess
import json
import pathlib
from distutils.version import LooseVersion
from typing import Iterable

import requests
from xml.etree import ElementTree

logger = logging.getLogger(__name__)


class GitLabRepo:
    version_regex = re.compile(r"^v\d+\.\d+\.\d+(\-rc\d+)?(\-ee)?")
    def __init__(self, owner: str, repo: str):
        self.owner = owner
        self.repo = repo

    @property
    def url(self):
        return f"https://gitlab.com/{self.owner}/{self.repo}"

    @property
    def tags(self) -> Iterable[str]:
        r = requests.get(self.url + "/tags?format=atom", stream=True)

        tree = ElementTree.fromstring(r.content)
        versions = [e.text for e in tree.findall('{http://www.w3.org/2005/Atom}entry/{http://www.w3.org/2005/Atom}title')]
        # filter out versions not matching version_regex
        versions = filter(self.version_regex.match, versions)
        
        # sort, but ignore v and -ee for sorting comparisons
        versions.sort(key=lambda x: LooseVersion(x.replace("v", "").replace("-ee", "")), reverse=True)
        return versions

    def get_git_hash(self, rev: str):
        out = subprocess.check_output(['nix-prefetch-git', self.url, rev])
        j = json.loads(out)
        return j['sha256']

    def get_deb_url(self, flavour: str, version: str, arch: str = 'amd64') -> str:
        """
        gitlab builds debian packages, which we currently need as we don't build the frontend on our own
        this returns the url of a given flavour, version and arch
        :param flavour: 'ce' or 'ee'
        :param version: a version, without 'v' prefix and '-ee' suffix
        :param arch: amd64
        :return: url of the debian package
        """
        if self.owner != "gitlab-org" or self.repo not in ['gitlab-ce', 'gitlab-ee']:
            raise Exception(f"don't know how to get deb_url for {self.url}")
        return f"https://packages.gitlab.com/gitlab/gitlab-{flavour}/packages" + \
               f"/debian/stretch/gitlab-{flavour}_{version}-{flavour}.0_{arch}.deb/download.deb"

    def get_deb_hash(self, flavour: str, version: str) -> str:
        out = subprocess.check_output(['nix-prefetch-url', self.get_deb_url(flavour, version)])
        return out.decode('utf-8').strip()

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

    def get_data(self, rev, flavour):
        version = self.rev2version(rev)

        passthru = {v: self.get_file(v, rev).strip() for v in ['GITALY_SERVER_VERSION', 'GITLAB_PAGES_VERSION',
                                                               'GITLAB_SHELL_VERSION', 'GITLAB_WORKHORSE_VERSION']}
        return dict(version=self.rev2version(rev),
                    repo_hash=self.get_git_hash(rev),
                    deb_hash=self.get_deb_hash(flavour, version),
                    deb_url=self.get_deb_url(flavour, version),
                    owner=self.owner,
                    repo=self.repo,
                    rev=rev,
                    passthru=passthru)


def _flavour2gitlabrepo(flavour: str):
    if flavour not in ['ce', 'ee']:
        raise Exception(f"unknown gitlab flavour: {flavour}, needs to be ce or ee")

    owner = 'gitlab-org'
    repo = 'gitlab-' + flavour

    return GitLabRepo(owner, repo)


def _update_data_json(filename: str, repo: GitLabRepo, rev: str, flavour: str):
    flavour_data = repo.get_data(rev, flavour)

    if not os.path.exists(filename):
        with open(filename, 'w') as f:
            json.dump({flavour: flavour_data}, f, indent=2)
    else:
        with open(filename, 'r+') as f:
            data = json.load(f)
            data[flavour] = flavour_data
            f.seek(0)
            f.truncate()
            json.dump(data, f, indent=2)


def _get_data_json():
    data_file_path = pathlib.Path(__file__).parent / 'data.json'
    with open(data_file_path, 'r') as f:
        return json.load(f)


def _call_update_source_version(pkg, version):
    """calls update-source-version from nixpkgs root dir"""
    nixpkgs_path = pathlib.Path(__file__).parent / '../../../../'
    return subprocess.check_output(['update-source-version', pkg, version], cwd=nixpkgs_path)


@click_log.simple_verbosity_option(logger)
@click.group()
def cli():
    pass


@cli.command('update-data')
@click.option('--rev', default='latest', help='The rev to use, \'latest\' points to the latest (stable) tag')
@click.argument('flavour')
def update_data(rev: str, flavour: str):
    """Update data.nix for a selected flavour"""
    r = _flavour2gitlabrepo(flavour)

    if rev == 'latest':
        # filter out pre and re releases
        rev = next(filter(lambda x: not ('rc' in x or x.endswith('pre')), r.tags))
    logger.debug(f"Using rev {rev}")

    version = r.rev2version(rev)
    logger.debug(f"Using version {version}")

    data_file_path = pathlib.Path(__file__).parent / 'data.json'

    _update_data_json(filename=data_file_path.as_posix(),
                      repo=r,
                      rev=rev,
                      flavour=flavour)


@cli.command('update-rubyenv')
@click.argument('flavour')
def update_rubyenv(flavour):
    """Update rubyEnv-${flavour}"""
    if flavour not in ['ce', 'ee']:
        raise Exception(f"unknown gitlab flavour: {flavour}, needs to be ce or ee")

    r = _flavour2gitlabrepo(flavour)
    rubyenv_dir = pathlib.Path(__file__).parent / f"rubyEnv-{flavour}"

    # load rev from data.json
    data = _get_data_json()
    rev = data[flavour]['rev']

    for fn in ['Gemfile.lock', 'Gemfile']:
        with open(rubyenv_dir / fn, 'w') as f:
            f.write(r.get_file(fn, rev))

    subprocess.check_output(['bundix'], cwd=rubyenv_dir)


@cli.command('update-gitaly')
def update_gitaly():
    """Update gitaly"""
    data = _get_data_json()
    gitaly_server_version = data['ce']['passthru']['GITALY_SERVER_VERSION']
    r = GitLabRepo('gitlab-org', 'gitaly')
    rubyenv_dir = pathlib.Path(__file__).parent / 'gitaly'

    for fn in ['Gemfile.lock', 'Gemfile']:
        with open(rubyenv_dir / fn, 'w') as f:
            f.write(r.get_file(f"ruby/{fn}", f"v{gitaly_server_version}"))

    subprocess.check_output(['bundix'], cwd=rubyenv_dir)
    # currently broken, as `gitaly.meta.position` returns
    # pkgs/development/go-modules/generic/default.nix
    # so update-source-version doesn't know where to update hashes
    # _call_update_source_version('gitaly', gitaly_server_version)
    gitaly_hash = r.get_git_hash(f"v{gitaly_server_version}")
    click.echo(f"Please update gitaly/default.nix to version {gitaly_server_version} and hash {gitaly_hash}")


@cli.command('update-gitlab-shell')
def update_gitlab_shell():
    """Update gitlab-shell"""
    data = _get_data_json()
    gitlab_shell_version = data['ce']['passthru']['GITLAB_SHELL_VERSION']
    _call_update_source_version('gitlab-shell', gitlab_shell_version)


@cli.command('update-gitlab-workhorse')
def update_gitlab_workhorse():
    """Update gitlab-shell"""
    data = _get_data_json()
    gitlab_workhorse_version = data['ce']['passthru']['GITLAB_WORKHORSE_VERSION']
    _call_update_source_version('gitlab-workhorse', gitlab_workhorse_version)


@cli.command('update-all')
@click.pass_context
def update_all(ctx):
    """Update gitlab ce and ee data.nix and rubyenvs to the latest stable release"""
    for flavour in ['ce', 'ee']:
        ctx.invoke(update_data, rev='latest', flavour=flavour)
        ctx.invoke(update_rubyenv, flavour=flavour)
    ctx.invoke(update_gitaly)
    ctx.invoke(update_gitlab_shell)
    ctx.invoke(update_gitlab_workhorse)


if __name__ == '__main__':
    cli()
