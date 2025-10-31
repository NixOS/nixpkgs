#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages (ps: [ ps.packaging ps.requests ])' nix-prefetch-github nixfmt-rfc-style yarn-berry_4.yarn-berry-fetcher
import json
import os
import re
import subprocess
import sys
import tempfile
from collections.abc import Iterable
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any

import requests
from packaging.version import Version

client = requests.Session()
github_token = os.environ.get("GITHUB_TOKEN")
if github_token:
    client.headers["Authorization"] = f"Bearer {github_token}"


def fetch_tags():
    url = "https://api.github.com/repos/graphql/graphiql/git/refs/tags/graphql-language-service"
    response = client.get(url)
    response.raise_for_status()
    return response.json()


@dataclass(frozen=True)
class PackageTag:
    ref: str
    url: str
    version: Version


def group_latest_tags(tags: list[Any]) -> dict[str, PackageTag]:
    packages: dict[str, PackageTag] = {}

    for tag in tags:
        match = re.match(r"refs/tags/([^@]*)@([\d.]+)", tag["ref"])
        if not match:
            print(f"skipping invalid tag {tag['ref']}")
            continue

        name = match.group(1)
        version = Version(match.group(2))

        package = packages.get(name)
        if not package or package.version < version:
            packages[name] = PackageTag(
                ref=tag["ref"],
                url=tag["object"]["url"],
                version=version,
            )

    return packages


@dataclass(frozen=True)
class Commit:
    date: datetime
    sha: str

    @staticmethod
    def fetch_latest(tags: Iterable[PackageTag]):
        latest = None

        for tag in tags:
            print(f"fetch tag {tag.url}", file=sys.stderr)
            response = client.get(tag.url)
            response.raise_for_status()
            data = response.json()
            commit = Commit(
                date=datetime.fromisoformat(data["tagger"]["date"]),
                sha=data["object"]["sha"],
            )
            if latest is None or latest.date < commit.date:
                latest = commit

        if latest is None:
            raise Exception("No tags provided")

        return latest

    def get_file(self, path: str):
        response = client.get(
            f"https://raw.githubusercontent.com/graphql/graphiql/{self.sha}/{path}"
        )
        response.raise_for_status()
        return response


def fetch_yarn_hashes(commit: Commit):
    with (
        tempfile.NamedTemporaryFile() as yarn_lock,
        tempfile.NamedTemporaryFile() as missing_hashes,
    ):
        response = commit.get_file("yarn.lock")
        yarn_lock.write(response.content)

        subprocess.run(
            ["yarn-berry-fetcher", "missing-hashes", yarn_lock.name],
            stdout=missing_hashes,
            check=True,
        )

        yarn_hash = subprocess.run(
            ["yarn-berry-fetcher", "prefetch", yarn_lock.name, missing_hashes.name],
            capture_output=True,
            text=True,
            check=True,
        )

        missing_hashes.seek(0)
        return (
            yarn_hash.stdout.strip(),
            missing_hashes.read().decode(),
        )


def fetch_version(commit: Commit):
    package_json = commit.get_file(
        "packages/graphql-language-service-cli/package.json"
    ).json()
    return f"{package_json['version']}-unstable-{commit.date.date().isoformat()}"


def fetch_source_hash(commit: Commit):
    res = subprocess.run(
        ["nix-prefetch-github", "graphql", "graphiql", "--rev", commit.sha],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(res.stdout)["hash"]


def main():
    tags = group_latest_tags(fetch_tags())
    commit = Commit.fetch_latest(tags.values())
    version = fetch_version(commit)

    prev_version = os.getenv("UPDATE_NIX_OLD_VERSION")
    if prev_version == version:
        print("No update available")
        exit()

    print(f"fetching yarn hashes for {commit.sha}")
    yarn_hash, missing_hashes = fetch_yarn_hashes(commit)

    print(f"fetching source hash for {commit.sha}")
    src_hash = fetch_source_hash(commit)

    version_file = Path(__file__).parent / "version.nix"
    with open(version_file, "w") as f:
        f.write(f"""
          {{ writeText }}:
          {{
            version = "{version}";
            src = {{
              rev = "{commit.sha}";
              hash = "{src_hash}";
            }};
            yarn = {{
              hash = "{yarn_hash}";
              missingHashes = writeText "missing-hashes.json" ''{missing_hashes}'';
            }};
            changelog = [{
            "\n".join(
                f"https://github.com/graphql/graphiql/blob/{tag.ref}/packages/{package}/CHANGELOG.md"
                for package, tag in tags.items()
            )
        }];
        }}
        """)
    subprocess.run(
        ["nixfmt", version_file],
        check=True,
    )


if __name__ == "__main__":
    main()
