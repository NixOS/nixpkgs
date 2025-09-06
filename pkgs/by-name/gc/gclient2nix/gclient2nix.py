#!/usr/bin/env python3
import base64
import json
import os
import subprocess
import re
import random
import sys
import tempfile
import logging
import click
import click_log
from typing import Optional
from urllib.request import urlopen
from joblib import Parallel, delayed, Memory
from platformdirs import user_cache_dir

sys.path.append("@depot_tools_checkout@")
import gclient_eval
import gclient_utils


logger = logging.getLogger(__name__)
click_log.basic_config(logger)

nixpkgs_path = "<nixpkgs>"

memory: Memory = Memory(user_cache_dir("gclient2nix"), verbose=0)

def cache(mem, **mem_kwargs):
    def cache_(f):
        f.__module__ = "gclient2nix"
        f.__qualname__ = f.__name__
        return mem.cache(f, **mem_kwargs)
    return cache_

@cache(memory)
def get_repo_hash(fetcher: str, args: dict) -> str:
    expr = f"(import {nixpkgs_path} {{}}).gclient2nix.fetchers.{fetcher}{{"
    for key, val in args.items():
        expr += f'{key}="{val}";'
    expr += "}"
    cmd = ["nurl", "-H", "--expr", expr]
    print(" ".join(cmd), file=sys.stderr)
    out = subprocess.check_output(cmd)
    return out.decode("utf-8").strip()


class Repo:
    fetcher: str
    args: dict

    def __init__(self) -> None:
        self.deps: dict = {}

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
            if dep_path in self.deps:
                self.deps[dep_path].get_deps(repo_vars, dep_path)

    def eval(self) -> None:
        self.get_deps(
            {
                **{
                f"checkout_{platform}": platform == "linux"
                for platform in ["ios", "chromeos", "android", "mac", "win", "linux", "fuchsia"]
                },
                **{
                f"checkout_{arch}": True
                for arch in ["x64", "arm64", "arm", "x86", "mips", "mips64", "ppc", "riscv64"]
                },
            },
            "",
        )

    def prefetch(self) -> None:
        self.hash = get_repo_hash(self.fetcher, self.args)

    def prefetch_all(self) -> int:
        return sum(
            [dep.prefetch_all() for [_, dep] in self.deps.items()],
            [delayed(self.prefetch)()],
        )

    def flatten_repr(self) -> dict:
        return {"fetcher": self.fetcher, "args": {**({"hash": self.hash} if hasattr(self, "hash") else {}), **self.args}}

    def flatten(self, path: str) -> dict:
        out = {path: self.flatten_repr()}
        for dep_path, dep in self.deps.items():
            out |= dep.flatten(dep_path)
        return out

    def get_file(self, filepath: str) -> str:
        raise NotImplementedError


class GitRepo(Repo):
    def __init__(self, url: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchgit"
        self.args = {
            "url": url,
            "rev" if re.match(r"[0-9a-f]{40}", rev) else "tag": rev,
        }


class GitHubRepo(Repo):
    def __init__(self, owner: str, repo: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchFromGitHub"
        self.args = {
            "owner": owner,
            "repo": repo,
            "rev" if re.match(r"[0-9a-f]{40}", rev) else "tag": rev,
        }

    def get_file(self, filepath: str) -> str:
        rev_or_tag = self.args['rev'] if 'rev' in self.args else f"refs/tags/{self.args['tag']}"
        return (
            urlopen(
                f"https://raw.githubusercontent.com/{self.args['owner']}/{self.args['repo']}/{rev_or_tag}/{filepath}"
            )
            .read()
            .decode("utf-8")
        )


class GitilesRepo(Repo):
    def __init__(self, url: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchFromGitiles"
        self.args = {
            "url": url,
            "rev" if re.match(r"[0-9a-f]{40}", rev) else "tag": rev,
        }

        # Quirk: Chromium source code exceeds the Hydra output limit
        # We prefer deleting test data over recompressing the sources into a
        # tarball, because the NAR will be compressed after the size check
        # anyways, so recompressing is more like bypassing the size limit
        # (making it count the compressed instead of uncompressed size)
        # rather than complying with it.
        if url == "https://chromium.googlesource.com/chromium/src.git":
            self.args["postFetch"] = "rm -r $out/third_party/blink/web_tests; "
            self.args["postFetch"] += "rm -r $out/content/test/data; "
            self.args["postFetch"] += "rm -rf $out/courgette/testdata; "
            self.args["postFetch"] += "rm -r $out/extensions/test/data; "
            self.args["postFetch"] += "rm -r $out/media/test/data; "

    def get_file(self, filepath: str) -> str:
        rev_or_tag = self.args['rev'] if 'rev' in self.args else f"refs/tags/{self.args['tag']}"
        return base64.b64decode(
            urlopen(
                f"{self.args['url']}/+/{rev_or_tag}/{filepath}?format=TEXT"
            ).read()
        ).decode("utf-8")



def repo_from_dep(dep: dict) -> Optional[Repo]:
    if "url" in dep:
        url, rev = gclient_utils.SplitUrlRevision(dep["url"])

        search_object = re.search(r"https://github.com/(.+)/(.+?)(\.git)?$", url)
        if search_object:
            return GitHubRepo(search_object.group(1), search_object.group(2), rev)

        if re.match(r"https://.+\.googlesource.com", url):
            return GitilesRepo(url, rev)

        return GitRepo(url, rev)
    else:
        # Not a git dependency; skip
        return None


@click.group()
def cli() -> None:
    """gclient2nix"""
    pass


@cli.command("eval", help="Evaluate and print the dependency tree of a gclient project")
@click.argument("url", required=True, type=str)
@click.option("--root", default="src", help="Root path, where the given url is placed", type=str)
def eval(url: str, root: str) -> None:
    repo = repo_from_dep({"url": url})
    repo.eval()
    print(json.dumps(repo.flatten(root), sort_keys=True, indent=4))


@cli.command("generate", help="Generate a dependencies description for a gclient project")
@click.argument("url", required=True, type=str)
@click.option("--root", default="src", help="Root path, where the given url is placed", type=str)
def generate(url: str, root: str) -> None:
    repo = repo_from_dep({"url": url})
    repo.eval()
    tasks = repo.prefetch_all()
    random.shuffle(tasks)
    task_results = {
        n[0]: n[1]
        for n in Parallel(n_jobs=20, require="sharedmem", return_as="generator")(tasks)
        if n != None
    }
    print(json.dumps(repo.flatten(root), sort_keys=True, indent=4))


if __name__ == "__main__":
    cli()
