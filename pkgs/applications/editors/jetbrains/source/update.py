#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.xmltodict nurl
import os
import subprocess
import pprint
import pathlib
from argparse import ArgumentParser
from xmltodict import parse
from json import dump, loads
from sys import stdout

def convert_hash_to_sri(base32: str) -> str:
    result = subprocess.run(["nix-hash", "--to-sri", "--type", "sha256", base32], capture_output=True, check=True, text=True)
    return result.stdout.strip()


def ensure_is_list(x):
    if type(x) != list:
        return [x]
    return x


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
                repositories.append(item['@value'])

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
        prefetch = subprocess.run(["nix-prefetch-url", "--type", "sha256", f"https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/kotlin/kotlin-jps-plugin-classpath/{version}/kotlin-jps-plugin-classpath-{version}.jar"], capture_output=True, check=True, text=True)

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

def get_args() -> (str, str):
    parser = ArgumentParser(
        description="Updates the IDEA / PyCharm source build infomations"
    )
    parser.add_argument("out", help="File to output json to")
    parser.add_argument("path", help="Path to the bin/versions.json file")
    args = parser.parse_args()
    return args.path, args.out


def main():
    versions_path, out = get_args()
    versions = loads(open(versions_path).read())
    idea_data = versions['x86_64-linux']['idea']
    pycharm_data = versions['x86_64-linux']['pycharm']

    #                                     source<jetbr.<editr.<applc.<pkgs  <nixpkgs
    nixpkgs_path = pathlib.Path(__file__).parent.parent.parent.parent.parent.parent.resolve()
    assert nixpkgs_path.joinpath("pkgs").is_dir(), f"nixpkgs_path ({nixpkgs_path}) doesn't seem to point to the root of the repo, please check if things were moved."

    result = { 'idea-oss': {}, 'pycharm-oss': {} }
    result['idea-oss']['version'] = idea_data['version']
    result['idea-oss']['buildNumber'] = idea_data['build_number']
    result['idea-oss']['buildType'] = 'idea'
    result['pycharm-oss']['version'] = pycharm_data['version']
    result['pycharm-oss']['buildNumber'] = pycharm_data['build_number']
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

    if out == "stdout":
        dump(result, stdout, indent=2)
    else:
        file = open(out, "w")
        dump(result, file, indent=2)
        file.write("\n")


if __name__ == '__main__':
    main()
