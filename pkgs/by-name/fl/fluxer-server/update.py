#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.semver nix-prefetch-github
from urllib.request import Request, urlopen
import dataclasses
import subprocess
import os.path
import semver
from typing import (
    Optional,
    Dict,
    List,
)
import json
import os
import sys
import argparse

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
NIXPKGS = os.path.abspath(os.path.join(SCRIPT_DIR, "../../../../"))


OWNER = "fluxerapp"
REPO = "fluxer"

@dataclasses.dataclass
class CargoPin:
    hash: str = ""
    libFluxcore: str = ""
    libFluxwebp: str = ""
    libGuildMemberListNif: str = ""
    libPushMarkdownPlaintext: str = ""

@dataclasses.dataclass
class Pin:
    owner: str
    repo: str
    filename: str

    rev: str
    version: str
    hash: str
    cargo: CargoPin
    pnpm: str = ""
    rebar: str = ""


    def write(self) -> None:
        if not self.filename:
            raise ValueError("No filename set")

        with open(self.filename, "w") as fd:
            pin = dataclasses.asdict(self)
            del pin["filename"]
            del pin["owner"]
            del pin["repo"]
            json.dump(pin, fd, indent=2)
            fd.write("\n")

    def print(self):
        pin = dataclasses.asdict(self)
        del pin["filename"]
        del pin["owner"]
        del pin["repo"]
        json.dump(pin, sys.stdout, indent=2)

    def get_fod_hash_from_expr(self, expr):
        """
        Builds `expr` and scans the output for the fod hash mismatch,
        then returns the actual hash.

        Panics if the build succeeds or no correct hash was reported.
        """

        proc = subprocess.run(["nix-build", "-I", NIXPKGS, "-E", expr], stderr=subprocess.PIPE)
        if proc.returncode != 1:
            raise ValueError("Expected nix-build to fail")

        # Iterate list in reverse order so we get the "got:" line early
        stderr = proc.stderr.decode()
        for line in stderr.split("\n")[::-1]:
            cols = line.split()
            if cols and cols[0] == "got:":
                print(f"-> {cols[1]}")
                return cols[1]

        print(stderr)
        raise ValueError("No fixed output hash found")

    def get_fod_hash_cargo(self, src_root):
        print(f"Getting fod hash for cargo deps at rev '{self.rev}' and root '{src_root}'")

        expr = f"""
            with import <nixpkgs> {{}};
            rustPlatform.fetchCargoVendor rec {{
                src = fetchFromGitHub {{
                    owner = "{self.owner}";
                    repo = "{self.repo}";
                    rev = "{self.rev}";
                    hash = "{self.hash}";
                }};
                hash = "";
                sourceRoot = "${{src.name}}/{src_root}";
            }}
        """

        return self.get_fod_hash_from_expr(expr)

    def get_fod_hash_pnpm(self):
        print(f"Getting fod hash for pnpm deps at rev '{self.rev}'")

        expr = f"""
            with import <nixpkgs> {{}};
            fetchPnpmDeps {{
                pname = "{self.repo}-prefetch";
                version = "0";
                src = fetchFromGitHub {{
                    owner = "{self.owner}";
                    repo = "{self.repo}";
                    rev = "{self.rev}";
                    hash = "{self.hash}";
                }};
                inherit pnpm;
                fetcherVersion = 4;
                hash = "";
            }}
        """

        return self.get_fod_hash_from_expr(expr)

    def get_fod_hash_rebar(self, path):
        print(f"Getting fod hash for rebar deps at rev '{self.rev}' and path '{path}'")

        expr = f"""
            with import <nixpkgs> {{}};
            (beamPackages.fetchRebar3Deps {{
                name = "{self.repo}-prefetch";
                version = "0";
                src = "${{fetchFromGitHub {{
                    owner = "{self.owner}";
                    repo = "{self.repo}";
                    rev = "{self.rev}";
                    hash = "{self.hash}";
                }}}}/{path}";
                sha256 = "";
            }}).overrideAttrs
                (
                    final: prev: {{
                    nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
                        git
                        cacert
                    ];
                    postInstall = ''
                        find $out -name .git -prune -execdir rm -r {{}} +
                    '';
                    }}
                )
        """

        return self.get_fod_hash_from_expr(expr)



def github_get(path: str) -> Dict:
    """Send a GET request to GitHub, optionally adding GITHUB_TOKEN auth header"""
    url = f"https://api.github.com/{path.lstrip('/')}"
    print(f"Retrieving {url}")

    req = Request(url)

    if "GITHUB_TOKEN" in os.environ:
        req.add_header("authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urlopen(req) as resp:
        return json.loads(resp.read())


def get_latest_release(owner: str, repo: str) -> str:
    return github_get(f"/repos/{owner}/{repo}/releases/latest")["tag_name"]


def prefetch_github(owner: str, repo: str, rev: str) -> str:
    """Prefetch GitHub rev and return SRI hash"""
    print(f"Prefetching {owner}/{repo}({rev})")

    proc = subprocess.run(
        ["nix-prefetch-github", owner, repo, "--rev", rev, "--fetch-submodules"],
        check=True,
        stdout=subprocess.PIPE,
    )

    return json.loads(proc.stdout)["hash"]



if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="update.py",
        description="Prefetches hashes for a specific fluxer revision"
    )
    parser.add_argument("--rev",
                        help="revision to prefetch (defaults to latest release)")
    parser.add_argument("--stdout",
                        action="store_true",
                        default=False,
                        help="write pin info to stdout instead of file")

    results = parser.parse_args()
    if help in results:
        parser.print_help()
        sys.exit(0)

    if not results.rev:
        rev = get_latest_release(OWNER, REPO)
        # Tag style: sub-service@yyyy.mdd.hhmmss
        [year, monthday, _] = rev.split("@")[1].split(".")
        month = monthday[:-2]
        day = monthday[-2:]
        version = f"0-unstable-{year}-{month:>02}-{day}"
    else:
        rev = results.rev
        version = "change-me"

    hash = prefetch_github(OWNER, REPO, rev)
    pin = Pin(rev=rev,
              hash=hash,
              version=version,
              owner=OWNER,
              repo=REPO,
              cargo=CargoPin(),
              filename=os.path.join(SCRIPT_DIR, "pin.json"))

    pin.cargo.hash = pin.get_fod_hash_cargo("")
    pin.cargo.libFluxcore = pin.get_fod_hash_cargo("fluxer_app/rust/libfluxcore")
    pin.cargo.libFluxwebp = pin.get_fod_hash_cargo("fluxer_app/rust/libfluxwebp")
    pin.cargo.libGuildMemberListNif = pin.get_fod_hash_cargo("fluxer_gateway/native/guild_member_list_oset_nif")
    pin.cargo.libPushMarkdownPlaintext = pin.get_fod_hash_cargo("fluxer_gateway/native/push_markdown_plaintext_nif")

    pin.pnpm = pin.get_fod_hash_pnpm()

    pin.rebar = pin.get_fod_hash_rebar("fluxer_gateway")

    if results.stdout:
        pin.print()
    else:
        pin.write()
