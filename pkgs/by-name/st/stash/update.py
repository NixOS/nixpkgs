#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 prefetch-yarn-deps nix-prefetch-git nix-prefetch

from pathlib import Path
from shutil import copyfile
from urllib.request import Request, urlopen
import json
import os
import subprocess


def run_external(args: list[str]):
    proc = subprocess.run(
        args,
        check=True,
        stdout=subprocess.PIPE,
    )

    return proc.stdout.strip().decode("utf8")

def get_latest_release_tag():
    req = Request("https://api.github.com/repos/stashapp/stash/tags?per_page=1")

    if "GITHUB_TOKEN" in os.environ:
        req.add_header("authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urlopen(req) as resp:
        return json.loads(resp.read())[0]

def prefetch_github(rev: str):
    print(f"Prefetching stashapp/stash({rev})")

    proc = run_external(["nix-prefetch-git", "--no-deepClone", "--rev", rev, f"https://github.com/stashapp/stash"])

    return json.loads(proc)

def prefetch_yarn(lock_file: str):
    print(f"Prefetching yarn deps")

    hash = run_external(["prefetch-yarn-deps", lock_file])

    return run_external(["nix", "hash", "convert", "--hash-algo", "sha256", hash])

def prefetch_go_modules(src: str, version: str):
    print(f"Prefetching go modules")
    expr = fr"""
        {{ sha256 }}: (buildGoModule {{
            pname = "stash";
            src = {src};
            version = "{version}";
            vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}).goModules.overrideAttrs (_: {{ modSha256 = sha256; }})
    """
    return run_external([
        "nix-prefetch",
        "--option",
        "extra-experimental-features",
        "flakes",
        expr
    ])


def save_version_json(version: dict[str, str]):
    print("Writing version.json")
    with open(Path(__file__).parent / "version.json", 'w') as f:
        json.dump(version, f, indent=2)
        f.write("\n")

if __name__ == "__main__":
    release = get_latest_release_tag()

    src = prefetch_github(release['name'])

    yarn_hash = prefetch_yarn(f"{src['path']}/ui/v2.5/yarn.lock")

    save_version_json({
        "version": release["name"][1:],
        "gitHash": release["commit"]["sha"][:8],
        "srcHash": src["hash"],
        "yarnHash": yarn_hash,
        "vendorHash": prefetch_go_modules(src["path"], release["name"][1:])
    })
