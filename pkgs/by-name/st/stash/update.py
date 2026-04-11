#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix-prefetch-git nix-prefetch

from pathlib import Path
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

def prefetch_pnpm():
    print("Prefetching pnpm deps")

    nixpkgs_path = Path(__file__).parent / "../../../../"
    output = subprocess.run(["nix-build", "-A", "stash"], text=True, cwd=nixpkgs_path, capture_output=True)

    # The line is of the form "    got:    sha256-xxx"
    lines = [i.strip() for i in output.stderr.splitlines()]
    new_hash_lines = [i.strip("got:").strip() for i in lines if i.startswith("got:")]

    if len(new_hash_lines) == 0:
        if output.returncode != 0:
            print("Error while fetching new hash with nix build")
            print(output.stderr)
        print("No hash change is needed")
        return None

    if len(new_hash_lines) > 1:
        print(new_hash_lines)
        raise Exception("Got an unexpected number of new hash lines:")

    return new_hash_lines[0]


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

def get_version_json():
    with open(Path(__file__).parent / "version.json", 'r') as f:
        return json.load(f)

def save_version_json(version: dict[str, str]):
    print("Writing version.json")
    with open(Path(__file__).parent / "version.json", 'w') as f:
        json.dump(version, f, indent=2)
        f.write("\n")

if __name__ == "__main__":
    version = get_version_json()

    release = get_latest_release_tag()

    src = prefetch_github(release["name"])

    version["version"] = release["name"][1:]
    version["gitHash"] = release["commit"]["sha"][:8]
    version["srcHash"] = src["hash"]
    version["vendorHash"] = prefetch_go_modules(src["path"], release["name"][1:])
    version["pnpmHash"] = prefetch_pnpm() or version["pnpmHash"] # If hash is unchanged, fall back to existing hash

    save_version_json(version)
