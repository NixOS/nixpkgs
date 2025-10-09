#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages(ps: [ps.requests ps.plumbum])' nix-prefetch nix-prefetch-git yarn-berry_4 yarn-berry_4.yarn-berry-fetcher prefetch-npm-deps
import json
import requests
import tempfile
import shutil

from pathlib import Path

from plumbum.cmd import nix_prefetch, nix_build, yarn, chmod, yarn_berry_fetcher, prefetch_npm_deps, diff

HERE = Path(__file__).parent

def write_release(release):
    with HERE.joinpath("release-data.json").open("w") as fd:
        json.dump(release, fd, indent=2)
        fd.write("\n")

def dict_to_argstr(d):
    args = "{ "
    for key, value in d.items():
        args += f'"{key}" = "{value}"; '
    args += "}"
    return args


package = HERE.joinpath("package.nix")


print("fetching latest release...")

latest = requests.get(
    "https://api.github.com/repos/laurent22/joplin/releases/latest"
).json()
tag = latest["tag_name"]
version = tag[1:]
release = {
    "version": version,
}

print(version)


print("prefetching source...")

release["hash"] = nix_prefetch[
    "--option",
    "extra-experimental-features",
    "flakes",
    "--tag",
    f"v{version}",
    "--rev",
    "--expr",
    "null",
    package
]().strip()

print(release["hash"])

# use new version and hash
write_release(release)

src_dir = nix_build[
    "--no-out-link",
    "-E",
    f"((import <nixpkgs> {{}}).callPackage {package} {{}}).src"
]().strip()

print(src_dir)


print("prefetching default plugins...")

default_plugins_dir = Path(src_dir).joinpath("packages/default-plugins")

with default_plugins_dir.joinpath("pluginRepositories.json").open() as fd:
    plugin_repositories = json.load(fd)

release["plugins"] = dict()

for key, value in plugin_repositories.items():
    print(key)

    plugin = {
        "name": "",
        "url": "",
        "hash": "",
        "npmDepsHash": "",
    }

    plugin["name"] = value["cloneUrl"].split("/")[-1].removesuffix(".git")

    plugin["url"] = f"{value["cloneUrl"].removesuffix('.git')}/archive/{value["commit"]}.tar.gz"

    plugin["hash"] = nix_prefetch.with_cwd(HERE)[
        "--option",
        "extra-experimental-features",
        "flakes",
        f"((import <nixpkgs> {{}}).callPackage ./buildPlugin.nix {dict_to_argstr(plugin)}).src"
    ]().strip()

    plugin_src = nix_build.with_cwd(HERE)[
        "--no-out-link",
        "-E",
        f"((import <nixpkgs> {{}}).callPackage ./buildPlugin.nix {dict_to_argstr(plugin)}).src"
    ]().strip()
    plugin["npmDepsHash"] = prefetch_npm_deps(Path(plugin_src).joinpath("package-lock.json")).strip()

    release["plugins"][key] = plugin


print("fetching missing-hashes...")

yarn_lock = Path(src_dir).joinpath("yarn.lock")
missing_hashes = HERE.joinpath("missing-hashes.json")

with missing_hashes.open("w") as fd:
    new_missing_hashes = yarn_berry_fetcher[
        "missing-hashes",
        yarn_lock
    ]()
    fd.write(new_missing_hashes)


print("prefetching offline cache...")

release["deps_hash"] = yarn_berry_fetcher[
    "prefetch",
    yarn_lock,
    missing_hashes
]().strip()


write_release(release)
