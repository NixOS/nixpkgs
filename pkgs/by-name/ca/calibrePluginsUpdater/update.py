from __future__ import annotations

import asyncio
import collections.abc as c
import dataclasses
import os
import typing as t
from pathlib import Path

import aiohttp
from bs4 import BeautifulSoup
from loguru import logger
from nupd import utils
from nupd.base import ABCBase
from nupd.cli import app
from nupd.models import Entry, EntryInfo, ImplClasses, MiniEntry, NupdModel

if t.TYPE_CHECKING:
    import collections.abc as c

ROOT = Path(__file__).parent
if "/nix/store" in str(ROOT):
    # we are bundled using nix, use working directory instead of root
    ROOT = Path.cwd()  # pyright: ignore[reportConstantRedefinition]


class SubprocessError(Exception): ...


async def execute_command(*command: str) -> str:
    process = await asyncio.create_subprocess_exec(
        *command,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        raise SubprocessError(
            f"{command[0]} returned exit code {process.returncode}"
            + f"\n{stdout=}\n{stderr=}"
        )
    if stderr.decode() != "":
        raise SubprocessError(
            f"{command[0]} wrote something to stderr!\n{stdout=}\n{stderr=}"
        )

    return stdout.decode()


class DownloadLink(NupdModel, frozen=True):
    file_name: str
    link: str


class CalibrePluginInfo(EntryInfo, frozen=True):
    name: str
    homepage: str
    description: str | None = None
    version: str
    platforms: tuple[str, ...]
    download_link: DownloadLink

    @property
    @t.override
    def id(self) -> str:
        return self.name.replace(" ", "-")

    @t.override
    async def fetch(self) -> CalibrePlugin:
        logger.info(f"Prefetching {self.name}...")
        hash = await execute_command(
            "nix-prefetch-url",
            # --print-path is needed so it wouldn't be printed to stderr, but stdout
            # (execute_command raises an error if something is printed to stderr)
            "--print-path",
            self.download_link.link,
        )
        hash = hash.split("\n")[0]  # remove --print-path
        sri_hash = await execute_command(
            "nix",
            "--experimental-features",
            "nix-command",
            "hash",
            "to-sri",
            "--type",
            "sha256",
            hash,
        )

        return CalibrePlugin(info=self, hash=sri_hash.strip())


class CalibrePluginSourceInfo(NupdModel, frozen=True):
    name: str
    url: str
    hash: str


class CalibreMiniEntry(MiniEntry[CalibrePluginInfo], frozen=True):
    hash: str


class CalibrePlugin(Entry[EntryInfo, CalibreMiniEntry], frozen=True):
    info: CalibrePluginInfo
    hash: str

    @t.override
    def minify(self) -> CalibreMiniEntry:
        return CalibreMiniEntry(info=self.info, hash=self.hash)


@dataclasses.dataclass
class CalibreImpl(ABCBase[CalibrePlugin, CalibrePluginInfo]):
    _default_input_file: os.PathLike[str] = dataclasses.field(
        init=False, default=Path("/dev/null")
    )
    _default_output_file: os.PathLike[str] = dataclasses.field(
        init=False,
        default=utils.NIXPKGS_PLACEHOLDER
        / "pkgs/applications/misc/calibre-plugins/generated.json",
    )

    @t.override
    async def get_all_entries(self) -> c.Iterable[CalibrePluginInfo]:
        async with aiohttp.ClientSession() as session:
            async with session.get(
                "https://plugins.calibre-ebook.com/",
                headers={"User-Agent": "nixpkgs@perchun.it"},
            ) as resp:
                resp.raise_for_status()
                html = await resp.text()

        return self._parse_html(html)

    def _parse_html(self, html: str) -> list[CalibrePluginInfo]:
        logger.info("Parsing html...")
        soup = BeautifulSoup(html, features="html.parser")

        passed_header = False
        plugins: list[CalibrePluginInfo] = []
        current_plugin = {}
        for element in soup.body.find_all(recursive=False):
            # <h1>
            #  <img src="//manual.calibre-ebook.com/_static/logo.png"/>
            #  Index of calibre plugins
            # </h1>
            # <div style="text-align:center">
            #  <a href="stats.html">
            #   Download counts for all plugins
            #  </a>
            # </div>
            if not passed_header and element.name != "h3":
                continue

            # <h3>
            #  <img src="plugin-icon.png"/>
            #  <a href="https://www.mobileread.com/forums/showthread.php?t=313848" title="Plugin forum thread">
            #   ACE
            #  </a>
            # </h3>
            if element.name == "h3":
                if passed_header:
                    plugins.append(CalibrePluginInfo(**current_plugin))
                    current_plugin = {}
                else:
                    passed_header = True

                # <a href="https://www.mobileread.com/forums/showthread.php?t=313848" title="Plugin forum thread">
                #  ACE
                # </a>
                link = element.find("a")
                current_plugin["homepage"] = link.attrs["href"]
                current_plugin["name"] = link.text
            # <p>
            #  Checks the accessibility of EPUB files with ACE.
            # </p>
            elif element.name == "p":
                current_plugin["description"] = element.text
            # <ul>
            #  <li>Version: <b>1.1.6</b></li>
            #  <li>Released: <b>27 Mar, 2023</b></li>
            #  <li>Author: Thiago Oliveira</li>
            #  <br/>
            #  <li>calibre: 2.0.0</li>
            #  <li>Platforms: linux, osx, windows</li>
            # </ul>
            elif element.name == "ul":
                for i, child in enumerate(element.find_all("li", recursive=False)):
                    # <li>Version: <b>1.1.6</b></li>
                    if i == 0:
                        current_plugin["version"] = child.b.text
                    # <li>Platforms: linux, osx, windows</li>
                    elif i == 4:
                        current_plugin["platforms"] = tuple(
                            child.text.strip().removeprefix("Platforms: ").split(", ")
                        )
            # <div class="end">
            #  <a download="ACE.zip" href="313848.zip" title="Download plugin">
            #   Download plugin
            #  </a>
            #  <span class="download-count">
            #   [5211 total downloads]
            #  </span>
            # </div>
            elif element.name == "div":
                # <a download="ACE.zip" href="313848.zip" title="Download plugin">
                #  Download plugin
                # </a>
                link = element.find("a")
                current_plugin["download_link"] = DownloadLink(
                    file_name=link.attrs["download"],
                    link=f"https://plugins.calibre-ebook.com/{link.attrs['href']}",
                )

        return plugins

    @t.override
    def write_entries_info(self, entries_info: c.Iterable[CalibrePluginInfo]) -> None:
        raise NotImplementedError(
            "All of the plugins are fetched from the official website, we"
            + " currently do not support plugins from other sources."
        )

    @t.override
    def parse_entry_id(self, to_parse: str) -> CalibrePluginInfo:
        raise ValueError(
            "Unknown plugin, are you sure you provided a correct plugin name?"
        )


if __name__ == "__main__":
    assert isinstance(app.info.context_settings, dict)
    app.info.context_settings["obj"] = ImplClasses(
        base=CalibreImpl,
        mini_entry=CalibreMiniEntry,
        entry=CalibrePlugin,
        entry_info=CalibrePluginInfo,
    )

    app()
