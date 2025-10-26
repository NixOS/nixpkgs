#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages(ps: [ps.requests ps.plumbum])' nurl nix-prefetch-git yarn-berry_4 yarn-berry_4.yarn-berry-fetcher prefetch-npm-deps
import json
import requests
import tempfile
import shutil

from pathlib import Path

from plumbum.cmd import nurl, nix_build, yarn, chmod, yarn_berry_fetcher, prefetch_npm_deps, diff, git, nix

HERE = Path(__file__).parent
NIXPKGS_ROOT = git.with_cwd(HERE)["rev-parse", "--show-toplevel"]().strip()

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

release["hash"] = nurl[
    "-e",
    f'(import {NIXPKGS_ROOT}/. {{}}).joplin-desktop.src.overrideAttrs(_:{{tag="{tag}";}})'
]().strip()

print(release["hash"])

# use new version and hash
write_release(release)

src_dir = nix_build[
    "--no-out-link",
    "-E",
    f"(import {NIXPKGS_ROOT}/. {{}}).joplin-desktop.src"
]().strip()

print(src_dir)


print("prefetching default plugins...")

default_plugins_dir = Path(src_dir).joinpath("packages/default-plugins")

with default_plugins_dir.joinpath("pluginRepositories.json").open() as fd:
    plugin_repositories = json.load(fd)

release["plugins"] = dict()

for key, value in plugin_repositories.items():
    if "package" in value:
        print("skipping npm-packaged plugin", key)
        continue

    print(key)

    plugin = {
        "name": value["cloneUrl"].split("/")[-1].removesuffix(".git"),
        "url": f"{value["cloneUrl"].removesuffix('.git')}/archive/{value["commit"]}.tar.gz",
    }

    fetched_src = json.loads(
        nix["store", "prefetch-file", "--json", "--unpack", plugin["url"]]()
    )
    plugin["hash"] = fetched_src["hash"]

    plugin["npmDepsHash"] = prefetch_npm_deps(Path(fetched_src["storePath"]).joinpath("package-lock.json")).strip()

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
