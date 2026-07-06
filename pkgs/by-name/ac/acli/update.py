#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p

import re
import json
import os
import sys
from urllib.request import urlopen, Request


def get_arch_os_key(url) -> str:
    if "darwin_amd64" in url:
        return "x86_64-darwin"
    elif "darwin_arm64" in url:
        return "aarch64-darwin"
    elif "linux_amd64" in url:
        return "x86_64-linux"
    elif "linux_arm64" in url:
        return "aarch64-linux"
    else:
        raise Exception(f"Unknown architecture: {url}")


def fetch_content(url: str) -> str:
    req = Request(url)
    if "GITHUB_TOKEN" in os.environ:
        req.add_header("Authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urlopen(req) as resp:
        return resp.read().decode("utf-8")


def parse_and_check(content):
    data = {"version": "", "sources": {}}

    version_match = re.search(r'version\s+"([^"]+)"', content)
    if not version_match:
        raise ValueError("Could not find version!")

    version = version_match.group(1)
    data["version"] = version
    print(f"Detected version: {version}")

    old_version = os.environ.get("UPDATE_NIX_OLD_VERSION")
    if old_version == version:
        print("No newer version available!")
        sys.exit(0)

    pattern = re.compile(
        r'url\s+"([^"]+)"(?:,\s*using:\s*\S+)?\s+sha256\s+"([a-fA-F0-9]+)"'
    )
    matches = pattern.findall(content)

    if not matches:
        raise ValueError(
            "Regex failed to find any URL/SHA256 pairs. The Formula format might have changed."
        )

    for url, hex_sha in matches:
        key = get_arch_os_key(url)

        data["sources"][key] = {"url": url, "sha256": hex_sha}

    data["sources"] = dict(sorted(data["sources"].items()))

    return data


def main():
    try:
        ruby_content = fetch_content(
            "https://github.com/atlassian/homebrew-acli/raw/refs/heads/main/Formula/acli.rb"
        )
        result = parse_and_check(ruby_content)

        output_path = os.path.join(
            os.path.dirname(os.path.realpath(__file__)), "sources.json"
        )

        with open(output_path, "w") as f:
            json.dump(result, f, indent=2)
            f.write("\n")

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
