import os
import requests
import re
import subprocess
import sys
import tempfile
from pathlib import Path

MAJOR_VERSION = 140


def get_tags() -> list[str]:
    token = os.environ.get("GITHUB_TOKEN")
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    response = requests.get(
        "https://api.github.com/repos/Betterbird/thunderbird-patches/tags",
        headers=headers,
    )
    if response.status_code != 200:
        raise RuntimeError(f"Failed to fetch release info: {response.status_code} ({response.json().get('message')})")
    tag_data = response.json()
    return [x["name"] for x in tag_data]


def run(*cmd: str | Path, **kwargs) -> str:
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=None,
        stdin=subprocess.DEVNULL,
        text=True,
        **kwargs,
    )
    (stdout_data, _) = proc.communicate()
    if proc.returncode != 0:
        raise RuntimeError(f"Failed to run command: {cmd!r} exited with code {proc.returncode}")
    return stdout_data.strip()


def convert_hash_to_sri(base32: str) -> str:
    return run("nix-hash", "--to-sri", "--type", "sha256", base32)


def main() -> int:
    self_path = Path(sys.argv[1]).absolute()
    nixpkgs_path = self_path.parent.parent.parent.parent

    print(f"{self_path=} {nixpkgs_path=}", file=sys.stderr)

    def nix_eval(attrpath: str) -> str:
        return run("nix-instantiate", "--eval", "--raw", "--attr", attrpath, nixpkgs_path)

    tags = get_tags()
    valid_tags = [tag for tag in tags if re.match(f"^{MAJOR_VERSION}\\..*-bb[0-9]+$", tag)]

    print(f"{tags=} {valid_tags=}", file=sys.stderr)

    old_rev = nix_eval("betterbird-unwrapped.betterbird-patches.rev")
    if old_rev not in valid_tags:
        raise RuntimeError(f"Don't know how to update, current rev {old_rev!r} not in {valid_tags!r}")

    new_rev = valid_tags[0]

    if new_rev == old_rev:
        # nothing to do
        return 0

    old_url = nix_eval("betterbird-unwrapped.betterbird-patches.url")
    new_url = old_url.replace(old_rev, new_rev)

    new_hash = run("nix-prefetch-url", "--type", "sha256", "--unpack", new_url)
    new_sri = convert_hash_to_sri(new_hash)

    old_sri = nix_eval("betterbird-unwrapped.betterbird-patches.hash")

    package_nix = self_path / "package.nix"

    package_nix.write_text(package_nix.read_text().replace(old_rev, new_rev).replace(old_sri, new_sri))

    with tempfile.TemporaryDirectory() as tempdir_str:
        tempdir = Path(tempdir_str)
        result = tempdir / "result"
        run("nix-build", "--expr", "let pkgs = import <nixpkgs> { }; in pkgs.srcOnly { inherit (pkgs.betterbird-unwrapped) name version stdenv; src = pkgs.betterbird-unwrapped.betterbird-patches; }", "--out-link", result, env={**os.environ, "NIX_PATH": f"nixpkgs={nixpkgs_path}"})

        conf_fn = result / f"{MAJOR_VERSION}/{MAJOR_VERSION}.sh"
        conf = {}
        for line in conf_fn.read_text().split("\n"):
            line = line.strip()
            if line == "" or line[0] == "#":
                continue
            name, val = line.split("=", 1)
            conf[name] = val

        def update_src(conf_name: str, attr_path: str):
            old_rev = nix_eval(f"{attr_path}.rev")
            new_rev = conf[f"{conf_name}_REV"]
            if old_rev == new_rev:
                return
            hg_url = nix_eval(f"{attr_path}.url")

            old_sri = nix_eval(f"{attr_path}.hash")
            new_hash = run("nix-prefetch-hg", hg_url, new_rev)
            new_sri = convert_hash_to_sri(new_hash)
            package_nix.write_text(
                package_nix.read_text()
                .replace(old_rev, new_rev)
                .replace(old_sri, new_sri)
            )

        update_src("MOZILLA", "betterbird-unwrapped.src")
        update_src("COMM", "betterbird-unwrapped.comm-source")

    return 0


if __name__ == "__main__":
    sys.exit(main())
