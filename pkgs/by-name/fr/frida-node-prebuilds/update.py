#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p cacert nix python3

import json
import re
import subprocess
from pathlib import Path
from urllib.request import urlopen


ASSETS = {
    "aarch64-darwin": "darwin-arm64",
    "x86_64-darwin": "darwin-x64",
    "aarch64-linux": "linux-arm64",
    "x86_64-linux": "linux-x64",
}

VERSION_KEYS = {
    "frida": "fridaVersion",
    "frida16": "frida16Version",
}


def run(args):
    return subprocess.run(args, check=True, stdout=subprocess.PIPE, text=True).stdout.strip()


def igf_version(repo_root):
    return json.loads(
        run(
            [
                "nix-instantiate",
                "--eval",
                "--strict",
                "--json",
                str(repo_root),
                "-A",
                "igf.version",
            ]
        )
    )


def locked_versions(repo_root):
    url = f"https://raw.githubusercontent.com/ChiChou/grapefruit/v{igf_version(repo_root)}/package-lock.json"
    with urlopen(url, timeout=30) as response:
        lock = json.load(response)

    return {
        "frida": lock["packages"]["node_modules/frida"]["version"],
        "frida16": lock["packages"]["node_modules/frida16"]["version"],
    }


def current_versions(package_nix):
    return {
        name: re.search(rf'{key} = "([^"]+)";', package_nix).group(1)
        for name, key in VERSION_KEYS.items()
    }


def source_hash(url):
    raw_hash = run(["nix-prefetch-url", "--type", "sha256", url])
    return run(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command",
            "hash",
            "convert",
            "--hash-algo",
            "sha256",
            "--to",
            "sri",
            raw_hash,
        ]
    )


def release_url(version, asset_system):
    return f"https://github.com/frida/frida/releases/download/{version}/frida-v{version}-napi-v8-{asset_system}.tar.gz"


def replace_version(package_nix, name, version):
    key = VERSION_KEYS[name]
    package_nix, count = re.subn(rf'{key} = "[^"]+";', f'{key} = "{version}";', package_nix, count=1)
    if count != 1:
        raise RuntimeError(f"Could not update {key}")
    return package_nix


def replace_hash(package_nix, system, name, hash_):
    pattern = re.compile(rf'({re.escape(system)} = \{{.*?{name} = ")[^"]+(";)', re.DOTALL)
    package_nix, count = pattern.subn(rf"\1{hash_}\2", package_nix, count=1)
    if count != 1:
        raise RuntimeError(f"Could not update {system}.{name}")
    return package_nix


def main():
    package_path = Path(__file__).with_name("package.nix")
    repo_root = package_path.parents[4]
    package_nix = package_path.read_text()
    current = current_versions(package_nix)

    for name, version in locked_versions(repo_root).items():
        if current[name] == version:
            print(f"{name} is up-to-date: {version}")
            continue

        package_nix = replace_version(package_nix, name, version)

        for system, asset_system in ASSETS.items():
            url = release_url(version, asset_system)
            print(f"Prefetching {system}.{name}: {url}")
            package_nix = replace_hash(package_nix, system, name, source_hash(url))

    package_path.write_text(package_nix)


if __name__ == "__main__":
    main()
