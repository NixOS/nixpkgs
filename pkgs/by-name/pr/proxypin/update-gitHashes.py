#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix-prefetch-git

import json
import subprocess
import sys
from pathlib import Path

THIS_FOLDER = Path(__file__).parent.resolve()
PUBSPEC_LOCK = THIS_FOLDER / "pubspec.lock.json"
GIT_HASHES = THIS_FOLDER / "gitHashes.json"


def fetch_git_hash(url: str, rev: str) -> str:
    result = subprocess.run(
        ["nix-prefetch-git", "--url", url, "--rev", rev],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)["hash"]


def main() -> None:
    if not PUBSPEC_LOCK.exists():
        sys.exit(1)
    try:
        data = json.loads(PUBSPEC_LOCK.read_text())
    except json.JSONDecodeError:
        sys.exit(1)
    output: dict[str, str] = {}
    for name, info in data.get("packages", {}).items():
        if info.get("source") != "git":
            continue
        desc = info.get("description")
        if not isinstance(desc, dict):
            continue
        url = desc.get("url")
        rev = desc.get("resolved-ref")
        if not (isinstance(url, str) and isinstance(rev, str)):
            continue
        try:
            package_hash = fetch_git_hash(url, rev)
        except subprocess.CalledProcessError:
            continue
        output[name] = package_hash
    GIT_HASHES.write_text(json.dumps(output, indent=2) + "\n")


if __name__ == "__main__":
    main()
