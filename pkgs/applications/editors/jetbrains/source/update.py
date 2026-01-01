#!/usr/bin/env nix-shell
<<<<<<< HEAD
#! nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.xmltodict python3.pkgs.requests nurl
import os
import subprocess
import pprint
import pathlib
import requests
import json
import re
=======
# ! nix-shell -i python3 -p python3 python3.pkgs.xmltodict
import os
import subprocess
import pprint
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
from argparse import ArgumentParser
from xmltodict import parse
from json import dump, loads
from sys import stdout
<<<<<<< HEAD
from packaging import version

UPDATES_URL = "https://www.jetbrains.com/updates/updates.xml"
IDES_FILE_PATH = pathlib.Path(__file__).parent.joinpath("..").joinpath("ides.json").resolve()

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

def convert_hash_to_sri(base32: str) -> str:
    result = subprocess.run(["nix-hash", "--to-sri", "--type", "sha256", base32], capture_output=True, check=True, text=True)
    return result.stdout.strip()


def ensure_is_list(x):
    if type(x) != list:
        return [x]
    return x


<<<<<<< HEAD
def one_or_more(x):
    return x if isinstance(x, list) else [x]


# TODO: Code duplication to update_bin.py - eventually refactor or merge scripts
def download_channels():
    print(f"Checking for updates from {UPDATES_URL}")
    updates_response = requests.get(UPDATES_URL)
    updates_response.raise_for_status()
    root = parse(updates_response.text)
    products = root["products"]["product"]
    return {
        channel["@name"]: channel
        for product in products
        if "channel" in product
        for channel in one_or_more(product["channel"])
    }


# TODO: Code duplication to update_bin.py - eventually refactor or merge scripts
def build_version(build):
    build_number = build["@fullNumber"] if "@fullNumber" in build else build["@number"]
    return version.parse(build_number)


# TODO: Code duplication to update_bin.py - eventually refactor or merge scripts
def latest_build(channel):
    builds = one_or_more(channel["build"])
    latest = max(builds, key=build_version)
    return latest


=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
def jar_repositories(root_path: str) -> list[str]:
    repositories = []
    file_contents = parse(open(root_path + "/.idea/jarRepositories.xml").read())
    component = file_contents['project']['component']
    if component['@name'] != 'RemoteRepositoriesConfiguration':
        return repositories
    options = component['remote-repository']
    for option in ensure_is_list(options):
        for item in option['option']:
            if item['@name'] == 'url':
<<<<<<< HEAD
                repositories.append(
                    # Remove protocol and cache-redirector server, we only want the original URL. We try both the original
                    # URL and the URL via the cache-redirector for download in build.nix
                    re.sub(r'^https?://', '', item['@value']).removeprefix("cache-redirector.jetbrains.com/")
                )
=======
                repositories.append(item['@value'])
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    return repositories


def kotlin_jps_plugin_info(root_path: str) -> (str, str):
    file_contents = parse(open(root_path + "/.idea/kotlinc.xml").read())
    components = file_contents['project']['component']
    for component in components:
        if component['@name'] != 'KotlinJpsPluginSettings':
            continue

        option = component['option']
        version = option['@value']

        print(f"* Prefetching Kotlin JPS Plugin version {version}...")
<<<<<<< HEAD
        prefetch = subprocess.run(["nix-prefetch-url", "--type", "sha256", f"https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/kotlin/kotlin-jps-plugin-classpath/{version}/kotlin-jps-plugin-classpath-{version}.jar"], capture_output=True, check=True, text=True)
=======
        prefetch = subprocess.run(["nix-prefetch-url", "--type", "sha256", f"https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies/org/jetbrains/kotlin/kotlin-jps-plugin-classpath/{version}/kotlin-jps-plugin-classpath-{version}.jar"], capture_output=True, check=True, text=True)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

        return (version, convert_hash_to_sri(prefetch.stdout.strip()))


def requested_kotlinc_version(root_path: str) -> str:
    file_contents = parse(open(root_path + "/.idea/kotlinc.xml").read())
    components = file_contents['project']['component']
    for component in components:
        if component['@name'] != 'KotlinJpsPluginSettings':
            continue

        option = component['option']
        version = option['@value']

        return version


def prefetch_intellij_community(variant: str, buildNumber: str) -> (str, str):
    print("* Prefetching IntelliJ community source code...")
    prefetch = subprocess.run(["nix-prefetch-url", "--print-path", "--unpack", "--name", "source", "--type", "sha256", f"https://github.com/jetbrains/intellij-community/archive/{variant}/{buildNumber}.tar.gz"], capture_output=True, check=True, text=True)
    parts = prefetch.stdout.strip().split()

    hash = convert_hash_to_sri(parts[0])
    outPath = parts[1]

    return (hash, outPath)


def prefetch_android(variant: str, buildNumber: str) -> str:
    print("* Prefetching Android plugin source code...")
    prefetch = subprocess.run(["nix-prefetch-url", "--unpack", "--name", "source", "--type", "sha256", f"https://github.com/jetbrains/android/archive/{variant}/{buildNumber}.tar.gz"], capture_output=True, check=True, text=True)
    return convert_hash_to_sri(prefetch.stdout.strip())


<<<<<<< HEAD
def generate_restarter_hash(nixpkgs_path: str, root_path: str) -> str:
    print("* Generating restarter Cargo hash...")
    root_name = pathlib.Path(root_path).name
    output = subprocess.run(["nurl", "--expr", f'''
        (import {nixpkgs_path} {{}}).rustPlatform.buildRustPackage {{
            name = "restarter";
            src = {root_path};
            sourceRoot = "{root_name}/native/restarter";
            cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}
    '''], capture_output=True, check=True, text=True)
    return output.stdout.strip()


def generate_jps_hash(nixpkgs_path: str, root_path: str) -> str:
    print("* Generating jps repo hash...")
    jps_repo_nix = pathlib.Path(__file__).parent.joinpath("jps_repo.nix").resolve()
    output = subprocess.run(["nurl", "--expr", f'''
        (import {nixpkgs_path} {{}}).callPackage {jps_repo_nix} {{
            jbr = (import {nixpkgs_path} {{}}).jetbrains.jdk-no-jcef;
            src = {root_path};
            jpsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}
    '''], capture_output=True, check=True, text=True)
    return output.stdout.strip()


def get_args() -> str:
=======
def get_args() -> (str, str):
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    parser = ArgumentParser(
        description="Updates the IDEA / PyCharm source build infomations"
    )
    parser.add_argument("out", help="File to output json to")
<<<<<<< HEAD
    args = parser.parse_args()
    return args.out


# TODO: Code duplication to update_bin.py - eventually refactor or merge scripts
def get_latest_versions(channels: dict, ides: dict, name: str) -> (str, str):
    update_channel = ides[name]['updateChannel']
    print(f"Fetching latest {name} (channel: {update_channel}) release...")
    channel = channels[update_channel]

    build = latest_build(channel)
    new_version = build["@version"]
    new_build_number = ""
    if "@fullNumber" not in build:
        new_build_number = build["@number"]
    else:
        new_build_number = build["@fullNumber"]
    version_number = new_version.split(' ')[0]

    print(f"* Version: {version_number} - Build: {new_build_number}")
    return version_number, new_build_number


def main():
    out = get_args()

    #                                     source<jetbr.<editr.<applc.<pkgs  <nixpkgs
    nixpkgs_path = pathlib.Path(__file__).parent.parent.parent.parent.parent.parent.resolve()
    assert nixpkgs_path.joinpath("pkgs").is_dir(), f"nixpkgs_path ({nixpkgs_path}) doesn't seem to point to the root of the repo, please check if things were moved."

    channels = download_channels()
    with open(IDES_FILE_PATH, "r") as ides_file:
        ides = json.load(ides_file)

    idea_version, idea_build = get_latest_versions(channels, ides, 'idea-oss')
    pycharm_version, pycharm_build = get_latest_versions(channels, ides, 'pycharm-oss')

    result = { 'idea-oss': {}, 'pycharm-oss': {} }
    result['idea-oss']['version'] = idea_version
    result['idea-oss']['buildNumber'] = idea_build
    result['idea-oss']['buildType'] = 'idea'
    result['pycharm-oss']['version'] = pycharm_version
    result['pycharm-oss']['buildNumber'] = pycharm_build
    result['pycharm-oss']['buildType'] = 'pycharm'
    print('Fetching IDEA info...')
    result['idea-oss']['ideaHash'], ideaOutPath = prefetch_intellij_community('idea', result['idea-oss']['buildNumber'])
    result['idea-oss']['androidHash'] = prefetch_android('idea', result['idea-oss']['buildNumber'])
    result['idea-oss']['jpsHash'] = generate_jps_hash(nixpkgs_path, ideaOutPath)
    result['idea-oss']['restarterHash'] = generate_restarter_hash(nixpkgs_path, ideaOutPath)
    result['idea-oss']['mvnDeps'] = 'idea_maven_artefacts.json'
    result['idea-oss']['repositories'] = jar_repositories(ideaOutPath)
    result['idea-oss']['kotlin-jps-plugin'] = {}
    result['idea-oss']['kotlin-jps-plugin']['version'], result['idea-oss']['kotlin-jps-plugin']['hash'] = kotlin_jps_plugin_info(ideaOutPath)
    kotlinc_version = requested_kotlinc_version(ideaOutPath)
    print(f"* Prefetched IDEA Open Source requested Kotlin compiler {kotlinc_version}")
    print('Fetching PyCharm info...')
    result['pycharm-oss']['ideaHash'], pycharmOutPath = prefetch_intellij_community('pycharm', result['pycharm-oss']['buildNumber'])
    result['pycharm-oss']['androidHash'] = prefetch_android('pycharm', result['pycharm-oss']['buildNumber'])
    result['pycharm-oss']['jpsHash'] = generate_jps_hash(nixpkgs_path, pycharmOutPath)
    result['pycharm-oss']['restarterHash'] = generate_restarter_hash(nixpkgs_path, pycharmOutPath)
    result['pycharm-oss']['mvnDeps'] = 'pycharm_maven_artefacts.json'
    result['pycharm-oss']['repositories'] = jar_repositories(pycharmOutPath)
    result['pycharm-oss']['kotlin-jps-plugin'] = {}
    result['pycharm-oss']['kotlin-jps-plugin']['version'], result['pycharm-oss']['kotlin-jps-plugin']['hash'] = kotlin_jps_plugin_info(pycharmOutPath)
    kotlinc_version = requested_kotlinc_version(pycharmOutPath)
    print(f"* Prefetched PyCharm Open Source requested Kotlin compiler {kotlinc_version}")
=======
    parser.add_argument("path", help="Path to the bin/versions.json file")
    args = parser.parse_args()
    return args.path, args.out


def main():
    versions_path, out = get_args()
    versions = loads(open(versions_path).read())
    idea_data = versions['x86_64-linux']['idea-community']
    pycharm_data = versions['x86_64-linux']['pycharm-community']

    result = { 'idea-community': {}, 'pycharm-community': {} }
    result['idea-community']['version'] = idea_data['version']
    result['idea-community']['buildNumber'] = idea_data['build_number']
    result['idea-community']['buildType'] = 'idea'
    result['pycharm-community']['version'] = pycharm_data['version']
    result['pycharm-community']['buildNumber'] = pycharm_data['build_number']
    result['pycharm-community']['buildType'] = 'pycharm'
    print('Fetching IDEA info...')
    result['idea-community']['ideaHash'], ideaOutPath = prefetch_intellij_community('idea', result['idea-community']['buildNumber'])
    result['idea-community']['androidHash'] = prefetch_android('idea', result['idea-community']['buildNumber'])
    result['idea-community']['jpsHash'] = ''
    result['idea-community']['restarterHash'] = ''
    result['idea-community']['mvnDeps'] = 'idea_maven_artefacts.json'
    result['idea-community']['repositories'] = jar_repositories(ideaOutPath)
    result['idea-community']['kotlin-jps-plugin'] = {}
    result['idea-community']['kotlin-jps-plugin']['version'], result['idea-community']['kotlin-jps-plugin']['hash'] = kotlin_jps_plugin_info(ideaOutPath)
    kotlinc_version = requested_kotlinc_version(ideaOutPath)
    print(f"* Prefetched IDEA Community requested Kotlin compiler {kotlinc_version}")
    print('Fetching PyCharm info...')
    result['pycharm-community']['ideaHash'], pycharmOutPath = prefetch_intellij_community('pycharm', result['pycharm-community']['buildNumber'])
    result['pycharm-community']['androidHash'] = prefetch_android('pycharm', result['pycharm-community']['buildNumber'])
    result['pycharm-community']['jpsHash'] = ''
    result['pycharm-community']['restarterHash'] = ''
    result['pycharm-community']['mvnDeps'] = 'pycharm_maven_artefacts.json'
    result['pycharm-community']['repositories'] = jar_repositories(pycharmOutPath)
    result['pycharm-community']['kotlin-jps-plugin'] = {}
    result['pycharm-community']['kotlin-jps-plugin']['version'], result['pycharm-community']['kotlin-jps-plugin']['hash'] = kotlin_jps_plugin_info(pycharmOutPath)
    kotlinc_version = requested_kotlinc_version(pycharmOutPath)
    print(f"* Prefetched PyCharm Community requested Kotlin compiler {kotlinc_version}")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    if out == "stdout":
        dump(result, stdout, indent=2)
    else:
        file = open(out, "w")
        dump(result, file, indent=2)
        file.write("\n")


if __name__ == '__main__':
    main()
