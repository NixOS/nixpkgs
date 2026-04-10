import dataclasses
import sys
from functools import cached_property
from urllib import request
from urllib.error import HTTPError

import requests
import xmltodict
from packaging import version

from jetbrains_nix_updater.config import SUPPORTED_SYSTEMS
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import convert_hash_to_sri, one_or_more

UPDATES_URL = "https://www.jetbrains.com/updates/updates.xml"


@dataclasses.dataclass
class HashedUrl:
    url: str

    @cached_property
    def sri_hash(self) -> str:
        return convert_hash_to_sri(self.sha256)

    @cached_property
    def sha256(self) -> str:
        print(f"[.] Downloading sha256 for {self.url}", file=sys.stderr)
        url = f"{self.url}.sha256"
        download_response = requests.get(url)
        download_response.raise_for_status()
        return download_response.content.decode("UTF-8").split(" ")[0]


@dataclasses.dataclass
class VersionInfo:
    version: str
    build_number: str
    urls: dict[str, HashedUrl]


class VersionFetcher:
    @cached_property
    def channels(self) -> dict:
        "updates.xml content"
        return self.download_channels()

    def latest_version_info(
        self, ide: Ide, ignore_no_url_error=False
    ) -> VersionInfo | None:
        if ide.update_info is None:
            print(
                f"[!] no update info for {ide.name} in `updateInfo.json` - skipping!",
                file=sys.stderr,
            )
            return None
        channel_name = ide.update_info["channel"]
        channel = self.channels.get(channel_name)
        if channel is None:
            print(
                f"[!] failed to find IDE channel {channel_name} - skipping! check {ide.name}'s `channel`!",
                file=sys.stderr,
            )
            return None
        try:
            build = self.latest_build(channel)
            new_version = build["@version"]
            if "@fullNumber" not in build:
                new_build_number = build["@number"]
            else:
                new_build_number = build["@fullNumber"]
            if "EAP" not in channel["@id"]:
                version_or_build_number = new_version
            else:
                version_or_build_number = new_build_number
            version_number = new_version.split(" ")[0]
            download_urls = {}
            for system in SUPPORTED_SYSTEMS:
                download_url = self.make_url(
                    ide.update_info["urls"].get(system, None),
                    version_or_build_number,
                    version_number,
                )
                if download_url:
                    download_urls[system] = HashedUrl(url=download_url)
                elif not ignore_no_url_error:
                    print(
                        f"[!] no valid URL found for '{ide.name}' for '{system}'! make sure `updater/updateInfo.json` contains an entry and is correct.",
                        file=sys.stderr,
                    )
            return VersionInfo(
                version=new_version,
                build_number=new_build_number,
                urls=download_urls,
            )
        except Exception as e:  # noqa: BLE001 -- Intentional safety net for unhandled fetch exceptions
            print(
                f"[!] exception while trying to fetch version: {e} - skipping!",
                file=sys.stderr,
            )
            return None

    @classmethod
    def latest_build(cls, channel: dict) -> dict:
        builds = one_or_more(channel["build"])
        latest = max(builds, key=cls.build_version)
        return latest

    @staticmethod
    def download_channels():
        print(f"[-] Checking for updates from {UPDATES_URL}")
        updates_response = requests.get(UPDATES_URL)
        updates_response.raise_for_status()
        root = xmltodict.parse(updates_response.text)
        products = root["products"]["product"]
        return {
            channel["@id"]: channel
            for product in products
            if "channel" in product
            for channel in one_or_more(product["channel"])
        }

    @staticmethod
    def build_version(build):
        build_number = (
            build["@fullNumber"] if "@fullNumber" in build else build["@number"]
        )
        return version.parse(build_number)

    @staticmethod
    def make_url(
        template: str | None, version_or_build_number: str, version_number: str
    ) -> str | None:
        if template is None:
            return None
        release = [str(n) for n in version.parse(version_number).release]
        for k in range(len(release), 0, -1):
            s = ".".join(release[0:k])
            url = template.format(version=version_or_build_number, versionMajorMinor=s)
            try:
                if request.urlopen(url).getcode() == 200:
                    return url
            except HTTPError:
                pass
        return None
