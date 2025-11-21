#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix-prefetch-git

from dataclasses import dataclass
import json
import subprocess


@dataclass
class GitDependency:
    name: str
    url: str
    revision: str


def get_git_deps(lock_data):
    for name, data in lock_data["packages"].items():
        if data["source"] == "git":
            desc = data["description"]
            yield GitDependency(
                name=name,
                url=desc["url"],
                revision=desc["resolved-ref"],
            )


def nix_prefetch_git(url: str, rev: str):
    result = subprocess.run(
        ["nix-prefetch-git", url, rev],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    )
    return json.loads(result.stdout)


if __name__ == "__main__":
    with open("pubspec.lock.json") as lock_file:
        lock_data = json.load(lock_file)
    git_hashes = {}
    for dep in get_git_deps(lock_data):
        data = nix_prefetch_git(dep.url, dep.revision)
        git_hashes[dep.name] = data["hash"]
    with open("git-hashes.json", "w") as output_file:
        json.dump(git_hashes, output_file, indent=2)
        output_file.write("\n")
