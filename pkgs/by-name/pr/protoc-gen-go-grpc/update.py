#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.httpx ])" nix-update

import os
import re
import subprocess

import httpx


URL = "https://api.github.com/repos/grpc/grpc-go/git/matching-refs/tags/cmd/protoc-gen-go-grpc/v"
TAG_RE = re.compile(r"^refs/tags/(cmd/protoc-gen-go-grpc/v(\d+)\.(\d+)\.(\d+))$")


def get_latest_tag() -> str:
    headers = {
        "Accept": "application/vnd.github+json",
    }
    token = os.getenv("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"

    with httpx.Client(timeout=30.0, follow_redirects=True) as client:
        response = client.get(URL, headers=headers)
        response.raise_for_status()
        refs = response.json()

    if not isinstance(refs, list):
        raise RuntimeError("Unexpected response from GitHub API")

    best_tag = None
    best_version = None
    for ref in refs:
        if not isinstance(ref, dict):
            continue
        ref_name = ref.get("ref", "")
        match = TAG_RE.fullmatch(ref_name)
        if match is None:
            continue
        version = tuple(int(part) for part in match.groups()[1:])
        if best_version is None or version > best_version:
            best_version = version
            best_tag = match.group(1)

    if best_tag is None:
        raise RuntimeError("No matching protoc-gen-go-grpc tags found")

    return best_tag


def main() -> int:
    latest_tag = get_latest_tag()
    version = latest_tag.removeprefix("cmd/protoc-gen-go-grpc/v")

    subprocess.run(
        [
            "nix-update",
            "protoc-gen-go-grpc",
            "--version",
            version,
        ],
        check=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
