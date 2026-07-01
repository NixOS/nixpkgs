#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix nix-update python3

# Bumps goose-cli to the latest upstream tag and refreshes the
# vendored librusty_v8 binaries used by the bundled V8 engine.
#
# nix-update handles version, src.hash and cargoHash; the rest of this
# script reads the V8 version from the new Cargo.lock and refreshes
# librusty_v8.nix with the matching archives from denoland/rusty_v8.

import json
import pathlib
import re
import subprocess
import tomllib
import urllib.request

OWNER = "aaif-goose"
REPO = "goose"
ARCHITECTURES = [
    ("x86_64-linux", "x86_64-unknown-linux-gnu"),
    ("aarch64-linux", "aarch64-unknown-linux-gnu"),
    ("x86_64-darwin", "x86_64-apple-darwin"),
    ("aarch64-darwin", "aarch64-apple-darwin"),
]
RUSTY_V8_PREFIXES = ["librusty_v8_simdutf_release", "librusty_v8_release"]

PACKAGE_DIR = pathlib.Path(__file__).resolve().parent
PACKAGE_FILE = PACKAGE_DIR / "package.nix"
LIBRUSTY_V8_FILE = PACKAGE_DIR / "librusty_v8.nix"


def log(msg: str) -> None:
    print(f"[update] {msg}", flush=True)


def replace_once(path: pathlib.Path, pattern: str, replacement: str) -> None:
    text = path.read_text()
    new_text, count = re.subn(pattern, replacement, text, count=1, flags=re.MULTILINE)
    if count != 1:
        raise SystemExit(f"unable to update {path}: {pattern}")
    path.write_text(new_text)


# Delegate version, src.hash and cargoHash refresh to nix-update.
log("Running nix-update goose-cli")
subprocess.check_call(["nix-update", "goose-cli"])

version = re.search(
    r'^  version = "([^"]+)";$',
    PACKAGE_FILE.read_text(),
    re.MULTILINE,
).group(1)
log(f"goose-cli is now at {version}")

# Read the V8 version vendored by this Goose release.
with urllib.request.urlopen(
    f"https://raw.githubusercontent.com/{OWNER}/{REPO}/v{version}/Cargo.lock"
) as response:
    cargo_lock = tomllib.loads(response.read().decode())
v8_version = next(
    (pkg["version"] for pkg in cargo_lock["package"] if pkg["name"] == "v8"),
    None,
)
if v8_version is None:
    raise SystemExit("unable to find v8 in Cargo.lock")
log(f"vendored V8: {v8_version}")

# Resolve the matching denoland/rusty_v8 release.
with urllib.request.urlopen(
    f"https://api.github.com/repos/denoland/rusty_v8/releases/tags/v{v8_version}"
) as response:
    release = json.load(response)
assets = {a["name"]: a["browser_download_url"] for a in release["assets"]}

# Prefer the simdutf-suffixed archives when both are published for this V8.
archive_prefix = next(
    prefix
    for prefix in RUSTY_V8_PREFIXES
    if any(name.startswith(f"{prefix}_") for name in assets)
)
log(f"archive prefix: {archive_prefix}")

hashes = {}
for nix_arch, rust_target in ARCHITECTURES:
    asset_name = f"{archive_prefix}_{rust_target}.a.gz"
    if asset_name not in assets:
        raise SystemExit(f"missing librusty_v8 asset {asset_name}")
    prefetched = json.loads(
        subprocess.check_output(
            ["nix", "store", "prefetch-file", "--json", assets[asset_name]],
            text=True,
        )
    )
    hashes[nix_arch] = prefetched["hash"]
    log(f"{nix_arch}: {hashes[nix_arch]}")

replace_once(
    LIBRUSTY_V8_FILE,
    r'^  version = "[^"]+";.*$',
    f"  version = \"{v8_version}\"; # From source's Cargo.lock",
)
replace_once(
    LIBRUSTY_V8_FILE,
    r'^  archivePrefix = "[^"]+";$',
    f'  archivePrefix = "{archive_prefix}";',
)
for arch, sri in hashes.items():
    replace_once(
        LIBRUSTY_V8_FILE,
        rf'^    {re.escape(arch)} = "[^"]+";$',
        f'    {arch} = "{sri}";',
    )

log("done")
