#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p python3 nix cacert

"""Update script for codex-acp package.

codex-acp depends on crates from zed-industries/codex via a git dependency.
To keep the Nix expression up to date, we need to:
- update codex-acp source hash,
- extract the pinned codex git revision from Cargo.lock,
- refresh node-version.txt hash for that codex revision,
- refresh codex source hash for vendored bubblewrap on Linux,
- recompute cargoHash.
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import tarfile
import tempfile
import urllib.request
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
NIXPKGS_ROOT = SCRIPT_DIR.parents[4]
HASHES_FILE = SCRIPT_DIR / "hashes.json"

OWNER = "zed-industries"
REPO = "codex-acp"
DUMMY_CARGO_HASH = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
ANSI_ESCAPE_RE = re.compile(r"\x1b\[[0-9;]*m")


def run(cmd: list[str], cwd: Path | None = None) -> str:
    result = subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        output = result.stderr.strip() or result.stdout.strip()
        msg = f"Command failed ({result.returncode}): {' '.join(cmd)}"
        if output:
            msg = f"{msg}\n{output}"
        raise RuntimeError(msg)
    return result.stdout.strip()


def github_request(url: str) -> dict:
    headers = {
        "Accept": "application/vnd.github+json",
    }
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"

    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode("utf-8"))


def fetch_latest_release(owner: str, repo: str) -> str:
    data = github_request(f"https://api.github.com/repos/{owner}/{repo}/releases/latest")
    tag_name = data["tag_name"]
    return tag_name[1:] if tag_name.startswith("v") else tag_name


def version_key(version: str) -> tuple[int, ...]:
    parts = re.findall(r"\d+", version)
    return tuple(int(part) for part in parts)


def should_update(current: str, latest: str) -> bool:
    return version_key(latest) > version_key(current)


def load_hashes(path: Path) -> dict[str, str]:
    with path.open() as f:
        return json.load(f)


def save_hashes(path: Path, data: dict[str, str]) -> None:
    with path.open("w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def prefetch_sri(url: str, *, unpack: bool = False) -> str:
    cmd = ["nix-prefetch-url", "--type", "sha256"]
    if unpack:
        cmd.append("--unpack")
    cmd.append(url)

    raw_hash = run(cmd, cwd=NIXPKGS_ROOT)
    return run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "hash",
            "to-sri",
            "--type",
            "sha256",
            raw_hash,
        ],
        cwd=NIXPKGS_ROOT,
    )


def extract_codex_rev_from_tarball(tag: str) -> str:
    """Extract zed-industries/codex git revision from codex-acp Cargo.lock."""
    url = f"https://github.com/{OWNER}/{REPO}/archive/refs/tags/{tag}.tar.gz"

    with tempfile.TemporaryDirectory() as tmpdir:
        tarball_path = Path(tmpdir) / "source.tar.gz"
        urllib.request.urlretrieve(url, tarball_path)

        with tarfile.open(tarball_path, "r:gz") as tar:
            for member in tar.getmembers():
                if not member.name.endswith("Cargo.lock"):
                    continue
                cargo_lock = tar.extractfile(member)
                if cargo_lock is None:
                    continue

                content = cargo_lock.read().decode("utf-8")
                match = re.search(r"zed-industries/codex\?branch=acp#([a-f0-9]+)", content)
                if match:
                    return match.group(1)

    raise RuntimeError("Could not extract codex git revision from Cargo.lock")


def calculate_dependency_hash(attr_path: str) -> str:
    result = subprocess.run(
        ["nix-build", "--no-out-link", "-A", attr_path],
        cwd=str(NIXPKGS_ROOT),
        check=False,
        capture_output=True,
        text=True,
    )
    output = ANSI_ESCAPE_RE.sub("", f"{result.stdout}\n{result.stderr}")

    match = re.search(r"got:\s*(sha256-[A-Za-z0-9+/=]+)", output)
    if match:
        return match.group(1)

    if result.returncode == 0:
        raise RuntimeError("nix-build unexpectedly succeeded with placeholder cargoHash")

    raise RuntimeError("Failed to parse cargoHash from nix-build output")


def main() -> None:
    data = load_hashes(HASHES_FILE)
    current = data["version"]
    latest = fetch_latest_release(OWNER, REPO)

    print(f"Current: {current}, Latest: {latest}")

    if not should_update(current, latest):
        print("Already up to date")
        return

    tag = f"v{latest}"
    print(f"Updating codex-acp to {latest}...")

    source_url = f"https://github.com/{OWNER}/{REPO}/archive/refs/tags/{tag}.tar.gz"
    print("Calculating source hash...")
    source_hash = prefetch_sri(source_url, unpack=True)
    print(f"  hash: {source_hash}")

    print("Extracting codex git revision from Cargo.lock...")
    codex_rev = extract_codex_rev_from_tarball(tag)
    print(f"  codexRev: {codex_rev}")

    codex_src_url = f"https://github.com/zed-industries/codex/archive/{codex_rev}.tar.gz"
    print("Calculating codex source hash...")
    codex_src_hash = prefetch_sri(codex_src_url, unpack=True)
    print(f"  codexSrcHash: {codex_src_hash}")

    node_version_url = (
        f"https://raw.githubusercontent.com/zed-industries/codex/{codex_rev}/"
        "codex-rs/node-version.txt"
    )
    print("Calculating node-version.txt hash...")
    node_version_hash = prefetch_sri(node_version_url, unpack=False)
    print(f"  nodeVersionHash: {node_version_hash}")

    data = {
        "version": latest,
        "hash": source_hash,
        "cargoHash": DUMMY_CARGO_HASH,
        "codexRev": codex_rev,
        "codexSrcHash": codex_src_hash,
        "nodeVersionHash": node_version_hash,
    }
    save_hashes(HASHES_FILE, data)

    print("Calculating cargoHash...")
    attr_path = os.environ.get("UPDATE_NIX_ATTR_PATH", "codex-acp")
    cargo_hash = calculate_dependency_hash(attr_path)
    print(f"  cargoHash: {cargo_hash}")

    data["cargoHash"] = cargo_hash
    save_hashes(HASHES_FILE, data)

    print(f"Updated to {latest}")


if __name__ == "__main__":
    main()
