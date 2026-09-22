#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.requests python3Packages.dataclasses-json

import json
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

import requests
from dataclasses_json import DataClassJsonMixin, LetterCase, config
from marshmallow import fields


@dataclass
class Download(DataClassJsonMixin):
    sha1: str
    size: int
    url: str


@dataclass
class Version(DataClassJsonMixin):
    id: str
    type: str
    url: str
    time: datetime = field(
        metadata=config(
            encoder=datetime.isoformat,
            decoder=datetime.fromisoformat,
            mm_field=fields.DateTime(format="iso"),
        )
    )
    release_time: datetime = field(
        metadata=config(
            encoder=datetime.isoformat,
            decoder=datetime.fromisoformat,
            mm_field=fields.DateTime(format="iso"),
            letter_case=LetterCase.CAMEL,
        )
    )

    def get_manifest(self) -> Any:
        """Return the version's manifest."""
        response = requests.get(self.url)
        response.raise_for_status()
        return response.json()

    def get_downloads(self) -> Dict[str, Download]:
        """
        Return all downloadable files from the version's manifest, in Download
        objects.
        """
        return {
            download_name: Download.from_dict(download_info)
            for download_name, download_info in self.get_manifest()["downloads"].items()
        }

    def get_java_version(self) -> Any:
        """
        Return the java version specified in a version's manifest, if it is
        present. Versions <= 1.6 do not specify this.
        """
        return self.get_manifest().get("javaVersion", {}).get("majorVersion", None)

    def get_server(self) -> Optional[Download]:
        """
        If the version has a server download available, return the Download
        object for the server download. If the version does not have a server
        download available, return None.
        """
        downloads = self.get_downloads()
        if "server" in downloads:
            return downloads["server"]
        return None


def get_versions() -> List[Version]:
    """Return a list of Version objects for all available versions."""
    response = requests.get(
        "https://launchermeta.mojang.com/mc/game/version_manifest.json"
    )
    response.raise_for_status()
    data = response.json()
    return [Version.from_dict(version) for version in data["versions"]]


def get_major_release(version_id: str) -> str:
    """
    Return the major release for a version. The major release for 1.17 and
    1.17.1 is 1.17.
    """
    if not len(version_id.split(".")) >= 2:
        raise ValueError(f"version not in expected format: '{version_id}'")
    return ".".join(version_id.split(".")[:2])


def group_major_releases(releases: List[Version]) -> Dict[str, List[Version]]:
    """
    Return a dictionary containing each version grouped by each major release.
    The key "1.17" contains a list with two Version objects, one for "1.17"
    and another for "1.17.1".
    """
    groups: Dict[str, List[Version]] = {}
    for release in releases:
        major_release = get_major_release(release.id)
        if major_release not in groups:
            groups[major_release] = []
        groups[major_release].append(release)
    return groups


def slugify(version: str) -> str:
    return version.replace(".", "-")


def get_changelog_url(version: str) -> Optional[str]:
    """
    Attempt to resolve the Minecraft changelog article URL.
    Returns the URL if it exists, otherwise None.
    """
    url = f"https://www.minecraft.net/en-us/article/minecraft-java-edition-{slugify(version)}"

    # our request is denied without a human user-agent
    headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
    }

    try:
        response = requests.head(url, headers=headers, timeout=3)
        if response.status_code == 200:
            return url
    except requests.RequestException as e:
        pass

    return None


def get_latest_major_releases(releases: List[Version]) -> Dict[str, Version]:
    """
    Return a dictionary containing the latest version for each major release.
    The latest major release for 1.16 is 1.16.5, so the key "1.16" contains a
    Version object for 1.16.5.
    """
    return {
        major_release: max(
            (
                release
                for release in releases
                if get_major_release(release.id) == major_release
            ),
            key=lambda x: tuple(map(int, x.id.split("."))),
        )
        for major_release in group_major_releases(releases)
    }


def generate() -> Dict[str, Dict[str, str]]:
    """
    Return a dictionary containing the latest url, sha1 and version for each major
    release.
    """
    versions = get_versions()
    releases = list(
        filter(lambda version: version.type == "release", versions)
    )  # remove snapshots and betas
    latest_major_releases = get_latest_major_releases(releases)

    servers = {
        version: Download.schema().dump(download_info)  # Download -> dict
        for version, download_info in {
            version: value.get_server()
            for version, value in latest_major_releases.items()
        }.items()
        if download_info is not None  # versions < 1.2 do not have a server
    }
    for server in servers.values():
        del server["size"]  # don't need it

    for version, server in servers.items():
        server["version"] = latest_major_releases[version].id
        server["javaVersion"] = latest_major_releases[version].get_java_version()
    return servers


def get_latest(servers: Dict[str, Dict[str, str]]) -> str | None:
    return max(
        (v.get("version") for v in servers.values()),
        key=lambda x: tuple(map(int, x.split("."))) if x is not None else (),
    )


def generate_commit(
    previous_servers: Dict[str, Dict[str, str]],
    servers: Dict[str, Dict[str, str]],
    versions_file: Path,
) -> List[Dict[str, str | list[str]]]:
    actions = []
    commit_body_lines = []

    old_latest = get_latest(previous_servers)
    new_latest = get_latest(servers)

    for major_version, server in servers.items():
        version = server.get("version")
        previous_server = previous_servers.get(major_version)

        if version is None:
            continue

        attribute = f"minecraftServers.vanilla-{slugify(major_version)}"

        if not previous_server:
            # this version didn't exist before
            # check if its now the latest version
            if version == new_latest:
                action = f"{old_latest} -> {new_latest}"
                attribute = "minecraft-server"
            else:
                action = f"init {version}"

        else:
            previous_version = previous_server.get("version")
            if previous_version == version:
                continue

            action = f"{previous_version} -> {version}"

        actions.append(action)

        commit_body_lines.append(f"{attribute}: {action}")

        changelog_url = get_changelog_url(version)
        if changelog_url:
            commit_body_lines.append(f"Release notes: {changelog_url}")

    if not commit_body_lines:
        return []

    if len(actions) == 1:
        commit_message = commit_body_lines[0]

        # the body should only be the release notes to avoid repetition
        # if the release notes don't exist this will be blank
        commit_body = "\n".join(commit_body_lines[1:]).strip()
    else:
        detailed_message = f"minecraft-server: {', '.join(actions)}"

        commit_message = (
            detailed_message
            if len(detailed_message) <= 72
            else "minecraft-server: update multiple versions"
        )

        commit_body = "\n".join(commit_body_lines).strip()

    commit_json = {
        "attrPath": "minecraftServers.vanilla",
        "files": [str(versions_file)],
        "commitMessage": commit_message,
    }

    if commit_body:
        commit_json["commitBody"] = commit_body

    return [commit_json]


if __name__ == "__main__":
    versions_file = Path(__file__).parent / "versions.json"

    with open(versions_file, "r") as file:
        previous_servers = json.load(file)

    servers = generate()

    commit_json = generate_commit(previous_servers, servers, versions_file)

    with open(versions_file, "w") as file:
        json.dump(servers, file, indent=2)
        file.write("\n")

    print(json.dumps(commit_json))
