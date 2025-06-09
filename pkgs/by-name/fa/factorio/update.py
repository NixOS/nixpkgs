#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.absl-py ps.requests ])"

from collections import defaultdict
import copy
from dataclasses import dataclass
import json
import os.path
from typing import Callable, Dict

from absl import app
from absl import flags
from absl import logging
import requests


FACTORIO_RELEASES = "https://factorio.com/api/latest-releases"
FACTORIO_HASHES = "https://factorio.com/download/sha256sums/"


FLAGS = flags.FLAGS

flags.DEFINE_string("out", "", "Output path for versions.json.")
flags.DEFINE_list(
    "release_type",
    "",
    "If non-empty, a comma-separated list of release types to update (e.g. alpha).",
)
flags.DEFINE_list(
    "release_channel",
    "",
    "If non-empty, a comma-separated list of release channels to update (e.g. experimental).",
)


@dataclass
class System:
    nix_name: str
    url_name: str
    tar_name: str


@dataclass
class ReleaseType:
    name: str
    hash_filename_format: list[str]
    needs_auth: bool = False


@dataclass
class ReleaseChannel:
    name: str


FactorioVersionsJSON = Dict[str, Dict[str, str]]
OurVersionJSON = Dict[str, Dict[str, Dict[str, Dict[str, str]]]]

FactorioHashes = Dict[str, str]


SYSTEMS = [
    System(nix_name="x86_64-linux", url_name="linux64", tar_name="x64"),
]

RELEASE_TYPES = [
    ReleaseType(
        "alpha",
        needs_auth=True,
        hash_filename_format=["factorio_linux_{version}.tar.xz"],
    ),
    ReleaseType("demo", hash_filename_format=["factorio-demo_linux_{version}.tar.xz"]),
    ReleaseType(
        "headless",
        hash_filename_format=[
            "factorio-headless_linux_{version}.tar.xz",
            "factorio_headless_x64_{version}.tar.xz",
        ],
    ),
    ReleaseType(
        "expansion",
        needs_auth=True,
        hash_filename_format=["factorio-space-age_linux_{version}.tar.xz"],
    ),
]

RELEASE_CHANNELS = [
    ReleaseChannel("experimental"),
    ReleaseChannel("stable"),
]


def find_versions_json() -> str:
    if FLAGS.out:
        return FLAGS.out
    try_paths = ["pkgs/by-name/fa/factorio/versions.json", "versions.json"]
    for path in try_paths:
        if os.path.exists(path):
            return path
    raise Exception(
        "Couldn't figure out where to write versions.json; try specifying --out"
    )


def fetch_versions() -> FactorioVersionsJSON:
    return json.loads(requests.get(FACTORIO_RELEASES).text)


def fetch_hashes() -> FactorioHashes:
    resp = requests.get(FACTORIO_HASHES)
    resp.raise_for_status()
    out = {}
    for ln in resp.text.split("\n"):
        ln = ln.strip()
        if not ln:
            continue
        sha256, filename = ln.split()
        out[filename] = sha256
    return out


def generate_our_versions(factorio_versions: FactorioVersionsJSON) -> OurVersionJSON:
    def rec_dd():
        return defaultdict(rec_dd)

    output = rec_dd()

    # Deal with times where there's no experimental version
    for rc in RELEASE_CHANNELS:
        if rc.name not in factorio_versions or not factorio_versions[rc.name]:
            factorio_versions[rc.name] = factorio_versions["stable"]
        for rt in RELEASE_TYPES:
            if (
                rt.name not in factorio_versions[rc.name]
                or not factorio_versions[rc.name][rt.name]
            ):
                factorio_versions[rc.name][rt.name] = factorio_versions["stable"][
                    rt.name
                ]

    for system in SYSTEMS:
        for release_type in RELEASE_TYPES:
            for release_channel in RELEASE_CHANNELS:
                version = factorio_versions[release_channel.name].get(release_type.name)
                if version is None:
                    continue
                this_release = {
                    "name": f"factorio_{release_type.name}_{system.tar_name}-{version}.tar.xz",
                    "url": f"https://factorio.com/get-download/{version}/{release_type.name}/{system.url_name}",
                    "version": version,
                    "needsAuth": release_type.needs_auth,
                    "candidateHashFilenames": [
                        fmt.format(version=version)
                        for fmt in release_type.hash_filename_format
                    ],
                    "tarDirectory": system.tar_name,
                }
                output[system.nix_name][release_type.name][release_channel.name] = (
                    this_release
                )
    return output


def iter_version(
    versions: OurVersionJSON,
    it: Callable[[str, str, str, Dict[str, str]], Dict[str, str]],
) -> OurVersionJSON:
    versions = copy.deepcopy(versions)
    for system_name, system in versions.items():
        for release_type_name, release_type in system.items():
            for release_channel_name, release in release_type.items():
                release_type[release_channel_name] = it(
                    system_name, release_type_name, release_channel_name, dict(release)
                )
    return versions


def merge_versions(old: OurVersionJSON, new: OurVersionJSON) -> OurVersionJSON:
    """Copies already-known hashes from version.json to avoid having to re-fetch."""

    def _merge_version(
        system_name: str,
        release_type_name: str,
        release_channel_name: str,
        release: Dict[str, str],
    ) -> Dict[str, str]:
        old_system = old.get(system_name, {})
        old_release_type = old_system.get(release_type_name, {})
        old_release = old_release_type.get(release_channel_name, {})
        if FLAGS.release_type and release_type_name not in FLAGS.release_type:
            logging.info(
                "%s/%s/%s: not in --release_type, not updating",
                system_name,
                release_type_name,
                release_channel_name,
            )
            return old_release
        if FLAGS.release_channel and release_channel_name not in FLAGS.release_channel:
            logging.info(
                "%s/%s/%s: not in --release_channel, not updating",
                system_name,
                release_type_name,
                release_channel_name,
            )
            return old_release
        if "sha256" not in old_release:
            logging.info(
                "%s/%s/%s: not copying sha256 since it's missing",
                system_name,
                release_type_name,
                release_channel_name,
            )
            return release
        if not all(
            old_release.get(k, None) == release[k] for k in ["name", "version", "url"]
        ):
            logging.info(
                "%s/%s/%s: not copying sha256 due to mismatch",
                system_name,
                release_type_name,
                release_channel_name,
            )
            return release
        release["sha256"] = old_release["sha256"]
        return release

    return iter_version(new, _merge_version)


def fill_in_hash(
    versions: OurVersionJSON, factorio_hashes: FactorioHashes
) -> OurVersionJSON:
    """Fill in sha256 hashes for anything missing them."""

    def _fill_in_hash(
        system_name: str,
        release_type_name: str,
        release_channel_name: str,
        release: Dict[str, str],
    ) -> Dict[str, str]:
        for candidate_filename in release["candidateHashFilenames"]:
            if candidate_filename in factorio_hashes:
                release["sha256"] = factorio_hashes[candidate_filename]
                break
        else:
            logging.error(
                "%s/%s/%s: failed to find any of %s in %s",
                system_name,
                release_type_name,
                release_channel_name,
                release["candidateHashFilenames"],
                FACTORIO_HASHES,
            )
            return release
        if "sha256" in release:
            logging.info(
                "%s/%s/%s: skipping fetch, sha256 already present",
                system_name,
                release_type_name,
                release_channel_name,
            )
            return release
        return release

    return iter_version(versions, _fill_in_hash)


def main(argv):
    factorio_versions = fetch_versions()
    factorio_hashes = fetch_hashes()
    new_our_versions = generate_our_versions(factorio_versions)
    old_our_versions = None
    our_versions_path = find_versions_json()
    if our_versions_path:
        logging.info("Loading old versions.json from %s", our_versions_path)
        with open(our_versions_path, "r") as f:
            old_our_versions = json.load(f)
    if old_our_versions:
        logging.info("Merging in old hashes")
        new_our_versions = merge_versions(old_our_versions, new_our_versions)
    logging.info("Updating hashes from Factorio SHA256")
    new_our_versions = fill_in_hash(new_our_versions, factorio_hashes)
    with open(our_versions_path, "w") as f:
        logging.info("Writing versions.json to %s", our_versions_path)
        json.dump(new_our_versions, f, sort_keys=True, indent=2)
        f.write("\n")


if __name__ == "__main__":
    app.run(main)
