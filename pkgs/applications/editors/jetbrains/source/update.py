#!/usr/bin/env nix-shell
# ! nix-shell -i python3 -p python3 python3.pkgs.xmltodict
import os
import subprocess
import pprint
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
        prefetch = subprocess.run(["nix-prefetch-url", "--type", "sha256", f"https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies/org/jetbrains/kotlin/kotlin-jps-plugin-classpath/{version}/kotlin-jps-plugin-classpath-{version}.jar"], capture_output=True, check=True, text=True)

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

    if out == "stdout":
        dump(result, stdout, indent=2)
    else:
        file = open(out, "w")
        dump(result, file, indent=2)
        file.write("\n")


if __name__ == '__main__':
    main()
