#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ nixpkgs-updaters-library ])"

from __future__ import annotations

import dataclasses
import os
import sys
import typing as t
from pathlib import Path

from loguru import logger

from nupd import utils
from nupd.base import ABCBase
from nupd.cli import app
from nupd.fetchers import nurl
from nupd.fetchers.github import (
    GHRepository,
    github_fetch_graphql,
    github_fetch_rest,
)
from nupd.inputs.csv import CsvInput
from nupd.models import Entry, EntryInfo, ImplClasses, MiniEntry, NupdModel

if t.TYPE_CHECKING:
    import collections.abc as c

# Always assunme CWD is the root of nixpkgs, later will figure out how to use the CLI flag
ROOT = Path.cwd() / "pkgs/applications/editors/vim/plugins"


class GHRepoInfo(NupdModel, frozen=True):
    """GitHub repository information container."""

    owner: str
    """GitHub repository owner/organization name"""
    name: str
    """Repository name"""

    @classmethod
    def parse(cls, input: str) -> t.Self:  # noqa: A002
        """Parse a GitHub URL into owner and repository name.

        Raises:
            ValueError: If URL is not a GitHub repository URL.
        """
        if not input.startswith("https://github.com/"):
            raise ValueError(
                "At this point, automatic updater for Vim plugins supports only"
                " GitHub. Instead, please package the plugin in question manually"
            )

        input = (  # noqa: A001
            input.removeprefix("https://github.com/")
            .removesuffix(".git")
            .removesuffix("/")
        )
        owner, name = input.split("/")
        return cls(owner=owner, name=name)

    @property
    def url(self) -> str:
        return f"https://github.com/{self.owner}/{self.name}/"


class VimEntryInfo(EntryInfo, frozen=True):
    """Information about a Vim plugin entry (not yet prefetched)."""

    repo: GHRepoInfo
    branch: str | None
    alias: str | None

    @property
    @t.override
    def id(self) -> str:
        id = self.alias or self.repo.name  # noqa: A001
        return id.strip().replace(".", "-")

    @t.override
    async def fetch(self) -> VimEntry:
        """Fetch plugin information from GitHub.

        Returns:
            VimEntry containing fetched repository and prefetch information
        """
        logger.debug(f"Fetching from GitHub {self.repo.owner}/{self.repo.name}")
        github_token = os.environ.get("GITHUB_TOKEN")

        if github_token is not None:
            result = await github_fetch_graphql(
                self.repo.owner, self.repo.name, github_token
            )
        else:
            result = await github_fetch_rest(
                self.repo.owner, self.repo.name, github_token=None
            )

        if self.branch is not None:
            result = utils.replace(result, branch=self.branch, commit=None)

        # TODO: We could also handle redirects like this
        if (self.repo.owner, self.repo.name) != (result.owner, result.repo):
            ...

        result = await result.prefetch_commit(github_token=github_token)
        prefetched = await nurl.nurl(
            result.url,
            revision=result.commit.id if result.commit is not None else None,
            submodules=result.has_submodules,
        )
        return VimEntry(info=self, fetched=result, nurl_result=prefetched)


class VimMiniEntry(MiniEntry[VimEntryInfo], frozen=True):
    version: str
    nurl_result: nurl.NurlResult
    description: str | None
    homepage: str | None
    license: str | None


class VimEntry(Entry[EntryInfo, VimMiniEntry], frozen=True):
    """Represents a Vim plugin entry with fetched information.

    Attributes:
        info: The entry info instance, it was fetched from.
    """

    info: VimEntryInfo
    fetched: GHRepository
    nurl_result: nurl.NurlResult

    @t.override
    def minify(self) -> VimMiniEntry:
        assert self.fetched.commit is not None, "This plugin was not prefetched!"

        return VimMiniEntry(
            info=self.info,
            version=f"0-unstable-{self.fetched.commit.date.strftime('%Y-%m-%d')}",
            nurl_result=self.nurl_result,
            description=self.fetched.meta.description,
            homepage=self.fetched.meta.homepage,
            license=self.fetched.meta.license,
        )


@dataclasses.dataclass
class VimImpl(ABCBase[VimEntry, VimEntryInfo]):
    """Implementation for managing Vim plugin entries.

    Handles reading/writing plugin information from CSV files and updating plugin data.
    """

    _default_input_file: Path = dataclasses.field(
        init=False, default=ROOT / "vim-plugin-names.csv"
    )
    _default_output_file: Path = dataclasses.field(
        init=False, default=ROOT / "generated.json"
    )

    @t.override
    async def get_all_entries(self) -> c.Iterable[VimEntryInfo]:
        """Read all plugin entries from the input CSV file."""

        def init_entry(args: c.Mapping[str, str]) -> VimEntryInfo:
            repo_url, branch, alias = (
                args["repo"],
                args["branch"],
                args["alias"],
            )

            if not branch:
                branch = None
            if not alias:
                alias = None

            return VimEntryInfo(
                repo=GHRepoInfo.parse(repo_url),
                branch=branch,
                alias=alias,
            )

        return CsvInput[VimEntryInfo](self.input_file).read(init_entry)

    @t.override
    def write_entries_info(self, entries_info: c.Iterable[VimEntryInfo]) -> None:
        """Write plugin entries to the CSV file."""

        def serialize(entry_info: VimEntryInfo) -> c.Mapping[str, str]:
            res = entry_info.model_dump(mode="json")
            res["repo"] = entry_info.repo.url
            return res

        CsvInput[VimEntryInfo](self.input_file, kwargs={"lineterminator": "\n"}).write(
            entries_info,
            serialize=serialize,
        )

    @t.override
    def parse_entry_id(self, to_parse: str) -> VimEntryInfo:
        """Parse a plugin entry identifier string.

        Format: "url[@branch] [as alias]"
        """
        url, branch, alias = to_parse, None, None

        if " as " in url:
            url, alias = url.split(" as ")
            alias = alias.strip()
        if "@" in url:
            url, branch = url.split("@")
            branch = branch.strip()

        return VimEntryInfo(
            repo=GHRepoInfo.parse(url.strip()),
            branch=branch,
            alias=alias,
        )


if __name__ == "__main__":
    if os.environ.get("GITHUB_TOKEN") is None and "update" in sys.argv:
        logger.warning(
            "Please provide GITHUB_TOKEN env variable to avoid rate limits, it"
            " is mandatory to run updates for all packages (or else you will be"
            " rate limited)"
        )

    assert isinstance(app.info.context_settings, dict)
    app.info.context_settings["obj"] = ImplClasses(
        base=VimImpl,
        mini_entry=VimMiniEntry,
        entry=VimEntry,
        entry_info=VimEntryInfo,
    )

    app()
