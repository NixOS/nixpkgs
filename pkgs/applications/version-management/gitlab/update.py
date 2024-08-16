#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i python3 -p bundix bundler nix-update nix python3 python3Packages.requests python3Packages.click python3Packages.click-log python3Packages.packaging prefetch-yarn-deps git

import click
import click_log
import re
import logging
import subprocess
import json
import pathlib
import tempfile
from packaging.version import Version
from typing import Iterable

import requests

NIXPKGS_PATH = pathlib.Path(__file__).parent / "../../../../"
GITLAB_DIR = pathlib.Path(__file__).parent

logger = logging.getLogger(__name__)
click_log.basic_config(logger)


class GitLabRepo:
    version_regex = re.compile(r"^v\d+\.\d+\.\d+(\-rc\d+)?(\-ee)?(\-gitlab)?")

    def __init__(self, owner: str = "gitlab-org", repo: str = "gitlab"):
        self.owner = owner
        self.repo = repo

    @property
    def url(self):
        return f"https://gitlab.com/{self.owner}/{self.repo}"

    @property
    def tags(self) -> Iterable[str]:
        """Returns a sorted list of repository tags"""
        r = requests.get(self.url + "/refs?sort=updated_desc&ref=master").json()
        tags = r.get("Tags", [])

        # filter out versions not matching version_regex
        versions = list(filter(self.version_regex.match, tags))

        # sort, but ignore v, -ee and -gitlab for sorting comparisons
        versions.sort(
            key=lambda x: Version(
                x.replace("v", "").replace("-ee", "").replace("-gitlab", "")
            ),
            reverse=True,
        )
        return versions
    def get_git_hash(self, rev: str):
        return (
            subprocess.check_output(
                [
                    "nix-prefetch-url",
                    "--unpack",
                    f"https://gitlab.com/{self.owner}/{self.repo}/-/archive/{rev}/{self.repo}-{rev}.tar.gz",
                ]
            )
            .decode("utf-8")
            .strip()
        )

    def get_yarn_hash(self, rev: str):
        with tempfile.TemporaryDirectory() as tmp_dir:
            with open(tmp_dir + "/yarn.lock", "w") as f:
                f.write(self.get_file("yarn.lock", rev))
            return (
                subprocess.check_output(["prefetch-yarn-deps", tmp_dir + "/yarn.lock"])
                .decode("utf-8")
                .strip()
            )

    @staticmethod
    def rev2version(tag: str) -> str:
        """
        normalize a tag to a version number.
        This obviously isn't very smart if we don't pass something that looks like a tag
        :param tag: the tag to normalize
        :return: a normalized version number
        """
        # strip v prefix
        version = re.sub(r"^v", "", tag)
        # strip -ee and -gitlab suffixes
        return re.sub(r"-(ee|gitlab)$", "", version)

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

        passthru = {
            v: self.get_file(v, rev).strip()
            for v in [
                "GITALY_SERVER_VERSION",
                "GITLAB_PAGES_VERSION",
                "GITLAB_SHELL_VERSION",
                "GITLAB_ELASTICSEARCH_INDEXER_VERSION",
            ]
        }
        passthru["GITLAB_WORKHORSE_VERSION"] = version

        return dict(
            version=self.rev2version(rev),
            repo_hash=self.get_git_hash(rev),
            yarn_hash=self.get_yarn_hash(rev),
            owner=self.owner,
            repo=self.repo,
            rev=rev,
            passthru=passthru,
        )


def _get_data_json():
    data_file_path = pathlib.Path(__file__).parent / "data.json"
    with open(data_file_path, "r") as f:
        return json.load(f)


def _call_nix_update(pkg, version):
    """calls nix-update from nixpkgs root dir"""
    return subprocess.check_output(
        ["nix-update", pkg, "--version", version], cwd=NIXPKGS_PATH
    )


@click_log.simple_verbosity_option(logger)
@click.group()
def cli():
    pass


@cli.command("update-data")
@click.option("--rev", default="latest", help="The rev to use (vX.Y.Z-ee), or 'latest'")
def update_data(rev: str):
    """Update data.json"""
    logger.info("Updating data.json")

    repo = GitLabRepo()
    if rev == "latest":
        # filter out pre and rc releases
        rev = next(filter(lambda x: not ("rc" in x or x.endswith("pre")), repo.tags))

    data_file_path = pathlib.Path(__file__).parent / "data.json"

    data = repo.get_data(rev)

    with open(data_file_path.as_posix(), "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


@cli.command("update-rubyenv")
def update_rubyenv():
    """Update rubyEnv"""
    logger.info("Updating gitlab")
    repo = GitLabRepo()
    rubyenv_dir = pathlib.Path(__file__).parent / "rubyEnv"

    # load rev from data.json
    data = _get_data_json()
    rev = data["rev"]
    version = data["version"]

    for fn in ["Gemfile.lock", "Gemfile"]:
        with open(rubyenv_dir / fn, "w") as f:
            f.write(repo.get_file(fn, rev))

    # patch for openssl 3.x support
    subprocess.check_output(
        ["sed", "-i", "s:'openssl', '2.*':'openssl', '3.0.2':g", "Gemfile"],
        cwd=rubyenv_dir,
    )

    # Un-vendor sidekiq
    #
    # The sidekiq dependency was vendored to maintain compatibility with Redis 6.0 (as
    # stated in this [comment]) but unfortunately, it seems to cause a crash in the
    # application, as noted in this [upstream issue].
    #
    # We can safely swap out the dependency, as our Redis release in nixpkgs is >= 7.0.
    #
    # [comment]: https://gitlab.com/gitlab-org/gitlab/-/issues/468435#note_1979750600
    # [upstream issue]: https://gitlab.com/gitlab-org/gitlab/-/issues/468435
    subprocess.check_output(
        ["sed", "-i", "s|gem 'sidekiq', path: 'vendor/gems/sidekiq-7.1.6', require: 'sidekiq'|gem 'sidekiq', '~> 7.1.6'|g", "Gemfile"],
        cwd=rubyenv_dir,
    )

    # Fetch vendored dependencies temporarily in order to build the gemset.nix
    subprocess.check_output(["mkdir", "-p", "vendor/gems", "gems"], cwd=rubyenv_dir)
    subprocess.check_output(
        [
            "sh",
            "-c",
            f"curl -L https://gitlab.com/gitlab-org/gitlab/-/archive/v{version}-ee/gitlab-v{version}-ee.tar.bz2?path=vendor/gems | tar -xj --strip-components=3",
        ],
        cwd=f"{rubyenv_dir}/vendor/gems",
    )
    subprocess.check_output(
        [
            "sh",
            "-c",
            f"curl -L https://gitlab.com/gitlab-org/gitlab/-/archive/v{version}-ee/gitlab-v{version}-ee.tar.bz2?path=gems | tar -xj --strip-components=2",
        ],
        cwd=f"{rubyenv_dir}/gems",
    )

    # Undo our gemset.nix patches so that bundix runs through
    subprocess.check_output(
        ["sed", "-i", "-e", "1d", "-e", "s:\\${src}/::g", "gemset.nix"], cwd=rubyenv_dir
    )

    subprocess.check_output(["bundle", "lock"], cwd=rubyenv_dir)
    subprocess.check_output(["bundix"], cwd=rubyenv_dir)

    subprocess.check_output(
        [
            "sed",
            "-i",
            "-e",
            "1i\\src:",
            "-e",
            's:path = \\(vendor/[^;]*\\);:path = "${src}/\\1";:g',
            "-e",
            's:path = \\(gems/[^;]*\\);:path = "${src}/\\1";:g',
            "gemset.nix",
        ],
        cwd=rubyenv_dir,
    )
    subprocess.check_output(["rm", "-rf", "vendor", "gems"], cwd=rubyenv_dir)


@cli.command("update-gitaly")
def update_gitaly():
    """Update gitaly"""
    logger.info("Updating gitaly")
    data = _get_data_json()
    gitaly_server_version = data['passthru']['GITALY_SERVER_VERSION']
    repo = GitLabRepo(repo="gitaly")
    gitaly_dir = pathlib.Path(__file__).parent / 'gitaly'

    makefile = repo.get_file("Makefile", f"v{gitaly_server_version}")
    makefile += "\nprint-%:;@echo $($*)\n"

    git_version = subprocess.run(["make", "-f", "-", "print-GIT_VERSION"], check=True, input=makefile, text=True, capture_output=True).stdout.strip()

    _call_nix_update("gitaly", gitaly_server_version)
    _call_nix_update("gitaly.git", git_version)


@cli.command("update-gitlab-pages")
def update_gitlab_pages():
    """Update gitlab-pages"""
    logger.info("Updating gitlab-pages")
    data = _get_data_json()
    gitlab_pages_version = data["passthru"]["GITLAB_PAGES_VERSION"]
    _call_nix_update("gitlab-pages", gitlab_pages_version)


def get_container_registry_version() -> str:
    """Returns the version attribute of gitlab-container-registry"""
    return subprocess.check_output(
        [
            "nix",
            "--experimental-features",
            "nix-command",
            "eval",
            "-f",
            ".",
            "--raw",
            "gitlab-container-registry.version",
        ],
        cwd=NIXPKGS_PATH,
    ).decode("utf-8")


@cli.command("update-gitlab-shell")
def update_gitlab_shell():
    """Update gitlab-shell"""
    logger.info("Updating gitlab-shell")
    data = _get_data_json()
    gitlab_shell_version = data["passthru"]["GITLAB_SHELL_VERSION"]
    _call_nix_update("gitlab-shell", gitlab_shell_version)


@cli.command("update-gitlab-workhorse")
def update_gitlab_workhorse():
    """Update gitlab-workhorse"""
    logger.info("Updating gitlab-workhorse")
    data = _get_data_json()
    gitlab_workhorse_version = data["passthru"]["GITLAB_WORKHORSE_VERSION"]
    _call_nix_update("gitlab-workhorse", gitlab_workhorse_version)


@cli.command("update-gitlab-container-registry")
@click.option("--rev", default="latest", help="The rev to use (vX.Y.Z-ee), or 'latest'")
@click.option(
    "--commit", is_flag=True, default=False, help="Commit the changes for you"
)
def update_gitlab_container_registry(rev: str, commit: bool):
    """Update gitlab-container-registry"""
    logger.info("Updading gitlab-container-registry")
    repo = GitLabRepo(repo="container-registry")
    old_container_registry_version = get_container_registry_version()

    if rev == "latest":
        rev = next(filter(lambda x: not ("rc" in x or x.endswith("pre")), repo.tags))

    version = repo.rev2version(rev)
    _call_nix_update("gitlab-container-registry", version)
    if commit:
        new_container_registry_version = get_container_registry_version()
        commit_container_registry(
            old_container_registry_version, new_container_registry_version
        )


@cli.command('update-gitlab-elasticsearch-indexer')
def update_gitlab_elasticsearch_indexer():
    """Update gitlab-elasticsearch-indexer"""
    data = _get_data_json()
    gitlab_elasticsearch_indexer_version = data['passthru']['GITLAB_ELASTICSEARCH_INDEXER_VERSION']
    _call_nix_update('gitlab-elasticsearch-indexer', gitlab_elasticsearch_indexer_version)


@cli.command("update-all")
@click.option("--rev", default="latest", help="The rev to use (vX.Y.Z-ee), or 'latest'")
@click.option(
    "--commit", is_flag=True, default=False, help="Commit the changes for you"
)
@click.pass_context
def update_all(ctx, rev: str, commit: bool):
    """Update all gitlab components to the latest stable release"""
    old_data_json = _get_data_json()
    old_container_registry_version = get_container_registry_version()

    ctx.invoke(update_data, rev=rev)

    new_data_json = _get_data_json()

    ctx.invoke(update_rubyenv)
    ctx.invoke(update_gitaly)
    ctx.invoke(update_gitlab_pages)
    ctx.invoke(update_gitlab_shell)
    ctx.invoke(update_gitlab_workhorse)
    ctx.invoke(update_gitlab_elasticsearch_indexer)
    if commit:
        commit_gitlab(
            old_data_json["version"], new_data_json["version"], new_data_json["rev"]
        )

    ctx.invoke(update_gitlab_container_registry)
    if commit:
        new_container_registry_version = get_container_registry_version()
        commit_container_registry(
            old_container_registry_version, new_container_registry_version
        )


def commit_gitlab(old_version: str, new_version: str, new_rev: str) -> None:
    """Commits the gitlab changes for you"""
    subprocess.run(
        [
            "git",
            "add",
            "data.json",
            "rubyEnv",
            "gitaly",
            "gitlab-pages",
            "gitlab-shell",
            "gitlab-workhorse",
            "gitlab-elasticsearch-indexer",
        ],
        cwd=GITLAB_DIR,
    )
    subprocess.run(
        [
            "git",
            "commit",
            "--message",
            f"""gitlab: {old_version} -> {new_version}\n\nhttps://gitlab.com/gitlab-org/gitlab/-/blob/{new_rev}/CHANGELOG.md""",
        ],
        cwd=GITLAB_DIR,
    )


def commit_container_registry(old_version: str, new_version: str) -> None:
    """Commits the gitlab-container-registry changes for you"""
    subprocess.run(["git", "add", "gitlab-container-registry"], cwd=GITLAB_DIR)
    subprocess.run(
        [
            "git",
            "commit",
            "--message",
            f"gitlab-container-registry: {old_version} -> {new_version}\n\nhttps://gitlab.com/gitlab-org/container-registry/-/blob/v{new_version}-gitlab/CHANGELOG.md",
        ],
        cwd=GITLAB_DIR,
    )


if __name__ == "__main__":
    cli()
