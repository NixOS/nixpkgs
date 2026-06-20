#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3
"""
This is a heavily simplified variant of electron's update.py
for use in ./update.mjs and should not be called manually.

It resolves chromium's DEPS file recursively when called with
a working depot_tools checkout and a ref to fetch and prints
the result as JSON to stdout.
"""
import base64
import json
from typing import Optional
from urllib.request import urlopen

import sys

if len(sys.argv) != 3:
    print("""This internal script has been called with the wrong amount of parameters.
This script is not supposed to be called manually.
Refer to ./update.mjs instead.""")
    exit(1)

_, depot_tools_checkout, chromium_version = sys.argv

sys.path.append(depot_tools_checkout)
import gclient_eval
import gclient_utils


class Repo:
    fetcher: str
    args: dict

    def __init__(self) -> None:
        self.deps: dict = {}
        self.hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

    def get_deps(self, repo_vars: dict, path: str) -> None:
        print(
            "evaluating " + json.dumps(self, default=vars, sort_keys=True),
            file=sys.stderr,
        )

        deps_file = self.get_file("DEPS")
        evaluated = gclient_eval.Parse(deps_file, vars_override=repo_vars, filename="DEPS")

        repo_vars = dict(evaluated.get("vars", {})) | repo_vars

        prefix = f"{path}/" if evaluated.get("use_relative_paths", False) else ""

        self.deps = {
            prefix + dep_name: repo_from_dep(dep)
            for dep_name, dep in evaluated.get("deps", {}).items()
            if (
                gclient_eval.EvaluateCondition(dep["condition"], repo_vars)
                if "condition" in dep
                else True
            )
            and repo_from_dep(dep) != None
        }

        for key in evaluated.get("recursedeps", []):
            dep_path = prefix + key
            if dep_path in self.deps and dep_path != "src/third_party/squirrel.mac":
                self.deps[dep_path].get_deps(repo_vars, dep_path)

    def flatten_repr(self) -> dict:
        return {"fetcher": self.fetcher, "hash": self.hash, **self.args}

    def flatten(self, path: str) -> dict:
        out = {path: self.flatten_repr()}
        for dep_path, dep in self.deps.items():
            out |= dep.flatten(dep_path)
        return out

    def get_file(self, filepath: str) -> str:
        raise NotImplementedError


class GitilesRepo(Repo):
    def __init__(self, url: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchFromGitiles"
        self.args = {
            "url": url,
            "rev": rev,
        }

    def get_file(self, filepath: str) -> str:
        return base64.b64decode(
            urlopen(
                f"{self.args['url']}/+/{self.args['rev']}/{filepath}?format=TEXT"
            ).read()
        ).decode("utf-8")


def repo_from_dep(dep: dict) -> Optional[Repo]:
    if "url" in dep:
        url, rev = gclient_utils.SplitUrlRevision(dep["url"])
        return GitilesRepo(url, rev)
    else:
        # Not a git dependency; skip
        return None



chromium = GitilesRepo("https://chromium.googlesource.com/chromium/src.git", chromium_version)
chromium.get_deps(
    {
        **{
        f"checkout_{platform}": platform == "linux" or platform == "x64" or platform == "arm64" or platform == "arm"
        for platform in ["ios", "chromeos", "android", "mac", "win", "linux"]
        },
        **{
        f"checkout_{arch}": True
        for arch in ["x64", "arm64", "arm", "x86", "mips", "mips64", "ppc", "riscv64"]
        },
    },
    "",
)
print(json.dumps(chromium.flatten("src")))
