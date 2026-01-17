# run using `nix run .\#calibrePluginsUpdater`
# don't forget to use `ruff format`!
from __future__ import annotations

import asyncio
import dataclasses
import json

import aiohttp
from bs4 import BeautifulSoup
from loguru import logger


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
            f"\n{stdout=}\n{stderr=}"
        )
    if stderr.decode() != "":
        raise SubprocessError(
            f"{command[0]} wrote something to stderr!\n{stdout=}\n{stderr=}"
        )

    return stdout.decode()


@dataclasses.dataclass
class DownloadLink:
    file_name: str
    link: str
    hash: str | None = None

    async def prefetch(self, semaphore: asyncio.Semaphore) -> None:
        async with semaphore:
            logger.info(f"Prefetching {self.link}")
            hash = await execute_command(
                "nix-prefetch-url",
                "--unpack",
                # --print-path is needed so it wouldn't be printed to stderr, but stdout
                # (execute_command raises an error if something is printed to stderr)
                "--print-path",
                self.link,
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
            self.hash = sri_hash.strip()


@dataclasses.dataclass
class CalibrePlugin:
    name: str | None = None
    homepage: str | None = None
    description: str | None = None
    version: str | None = None
    platforms: list[str] | None = None
    download_link: DownloadLink | None = None

    def sanitize(self) -> SanitizedCalibrePlugin:
        assert self.name is not None, repr(self)
        assert self.homepage is not None, repr(self)
        assert self.version is not None, repr(self)
        assert self.platforms is not None, repr(self)
        assert self.download_link is not None, repr(self)

        return SanitizedCalibrePlugin(
            name=self.name.strip(),
            homepage=self.homepage.strip(),
            description=self.description.strip()
            if self.description is not None
            else None,
            version=self.version.strip(),
            platforms=self.platforms,
            download_link=self.download_link,
        )


@dataclasses.dataclass(frozen=True)
class SanitizedCalibrePlugin:
    name: str
    homepage: str
    description: str | None
    version: str
    platforms: list[str]
    download_link: DownloadLink


def parse_html(html: str) -> list[SanitizedCalibrePlugin]:
    logger.info("Parsing html...")
    soup = BeautifulSoup(html, features="html.parser")

    passed_header = False
    plugins: list[SanitizedCalibrePlugin] = []
    current_plugin = CalibrePlugin()
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
                plugins.append(current_plugin.sanitize())
                current_plugin = CalibrePlugin()
            else:
                passed_header = True

            # <a href="https://www.mobileread.com/forums/showthread.php?t=313848" title="Plugin forum thread">
            #  ACE
            # </a>
            link = element.find("a")
            current_plugin.homepage = link.attrs["href"]
            current_plugin.name = link.text
        # <p>
        #  Checks the accessibility of EPUB files with ACE.
        # </p>
        elif element.name == "p":
            current_plugin.description = element.text
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
                    current_plugin.version = child.b.text
                # <li>Platforms: linux, osx, windows</li>
                elif i == 4:
                    current_plugin.platforms = (
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
            current_plugin.download_link = DownloadLink(
                file_name=link.attrs["download"],
                link=f"https://plugins.calibre-ebook.com/{link.attrs['href']}",
            )

    return plugins


async def prefetch_all_plugins(plugins: list[SanitizedCalibrePlugin]) -> None:
    semaphore = asyncio.Semaphore(20)
    done, _pending = await asyncio.wait(
        {
            asyncio.create_task(plugin.download_link.prefetch(semaphore))
            for plugin in plugins
        },
        return_when=asyncio.FIRST_EXCEPTION,
    )

    # collect exceptions, if those were raised
    for task in done:
        _ = task.result()


async def fetch():
    logger.info("Fetching html")
    async with aiohttp.ClientSession() as session:
        async with session.get(
            "https://plugins.calibre-ebook.com/",
            headers={"User-Agent": "nixpkgs@perchun.it"},
        ) as resp:
            resp.raise_for_status()
            html = await resp.text()

    plugins = parse_html(html)
    await prefetch_all_plugins(plugins)

    logger.info("Generating result JSON")
    result = {}
    for plugin in plugins:
        result[plugin.name] = {
            "version": plugin.version,
            "src": {
                "name": plugin.download_link.file_name,
                "url": plugin.download_link.link,
                "hash": plugin.download_link.hash,
            },
            "description": plugin.description,
            "homepage": plugin.homepage,
            "platforms": plugin.platforms,
        }

    with open("pkgs/applications/misc/calibre-plugins/generated.json", "w") as f:
        json.dump(result, f, indent=1)


if __name__ == "__main__":
    asyncio.run(fetch())
