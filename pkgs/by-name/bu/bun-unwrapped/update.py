#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix-prefetch-git nixfmt python3
"""Update Bun and all fixed build inputs used by the source package."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
from pathlib import Path

PACKAGE_DIRECTORY = Path(__file__).resolve().parent
ROOT = PACKAGE_DIRECTORY.parents[3]
PACKAGE = PACKAGE_DIRECTORY / "package.nix"
SOURCES = PACKAGE_DIRECTORY / "sources.nix"
WEBKIT = PACKAGE_DIRECTORY / "webkit.nix"
BUN_REPOSITORY = "https://github.com/oven-sh/bun.git"
WEBKIT_REPOSITORY = "https://github.com/oven-sh/WebKit.git"
FAKE_HASH = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

BOOTSTRAP_ASSETS = {
    "aarch64-darwin": "bun-darwin-aarch64",
    "aarch64-linux": "bun-linux-aarch64",
    "aarch64-linux-musl": "bun-linux-aarch64-musl",
    "x86_64-linux": "bun-linux-x64-baseline",
    "x86_64-linux-musl": "bun-linux-x64-musl-baseline",
}

# Bun keeps both glibc and musl optional dependencies for Linux targets.
NODE_MODULE_TARGETS = {
    "aarch64-darwin": ("darwin", "arm64"),
    "aarch64-linux": ("linux", "arm64"),
    "x86_64-linux": ("linux", "x64"),
}


@dataclass(frozen=True, slots=True)
class Download:
    name: str
    url: str
    hash: str = ""


def run(
    arguments: list[str],
    *,
    cwd: Path = ROOT,
    env: dict[str, str] | None = None,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    print("+", " ".join(arguments), flush=True)
    result = subprocess.run(
        arguments,
        cwd=cwd,
        env=env,
        check=False,
        text=True,
        capture_output=True,
    )
    if check and result.returncode != 0:
        print(result.stdout, end="")
        print(result.stderr, end="", file=sys.stderr)
        result.check_returncode()
    return result


def replace_once(text: str, pattern: str, replacement: str, *, flags: int = 0) -> str:
    updated, count = re.subn(pattern, replacement, text, count=1, flags=flags)
    if count != 1:
        raise RuntimeError(f"Expected one match for {pattern!r}, found {count}")
    return updated


def current_version() -> str:
    match = re.search(r'^  version = "([^"]+)";$', PACKAGE.read_text(), re.MULTILINE)
    if match is None:
        raise RuntimeError("Cannot find the current Bun version")
    return match.group(1)


def release_tags() -> dict[str, str]:
    result = run(
        [
            "git",
            "ls-remote",
            "--tags",
            "--refs",
            BUN_REPOSITORY,
            "refs/tags/bun-v*",
        ]
    )
    tags: dict[str, str] = {}
    for line in result.stdout.splitlines():
        revision, reference = line.split("\t", 1)
        match = re.fullmatch(r"refs/tags/bun-v(\d+\.\d+\.\d+)", reference)
        if match is not None:
            tags[match.group(1)] = revision
    if not tags:
        raise RuntimeError("No stable Bun release tags found")
    return tags


def version_key(version: str) -> tuple[int, int, int]:
    match = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)", version)
    if match is None:
        raise ValueError(f"Unsupported Bun version: {version}")
    return tuple(map(int, match.groups()))


def prefetch_file(url: str, *, unpack: bool = False) -> tuple[str, Path]:
    arguments = ["nix", "store", "prefetch-file", "--json"]
    if unpack:
        arguments.append("--unpack")
    arguments.append(url)
    payload = json.loads(run(arguments).stdout)
    return payload["hash"], Path(payload["storePath"])


def prefetch_download(download: Download) -> Download:
    hash_value, _ = prefetch_file(download.url)
    return Download(download.name, download.url, hash_value)


def prefetch_downloads(downloads: list[Download]) -> list[Download]:
    with ThreadPoolExecutor(max_workers=4) as executor:
        results = list(executor.map(prefetch_download, downloads))
    hashes = {download.name: download for download in results}
    return [hashes[download.name] for download in downloads]


def resolve_constant(text: str, expression: str, source: Path) -> str:
    expression = expression.strip()
    if expression.startswith('"'):
        return json.loads(expression)
    match = re.search(
        rf"(?:export\s+)?const\s+{re.escape(expression)}(?:\s*:[^=]+)?\s*=\s*\"([^\"]+)\"",
        text,
    )
    if match is None:
        raise RuntimeError(f"Cannot resolve {expression} in {source}")
    return match.group(1)


def validate_llvm_version(source: Path) -> None:
    tools = (source / "scripts" / "build" / "tools.ts").read_text()
    match = re.search(r'export const LLVM_VERSION = "([^"]+)";', tools)
    if match is None:
        raise RuntimeError("Cannot find Bun's required LLVM version")
    if not match.group(1).startswith("21.1."):
        raise RuntimeError(
            f"The new Bun source requires LLVM {match.group(1)}; "
            "update llvmPackages_21 before updating the package"
        )


def source_downloads(source: Path) -> list[Download]:
    dependency_directory = source / "scripts" / "build" / "deps"
    dependencies: dict[str, Download] = {}

    for path in dependency_directory.glob("*.ts"):
        text = path.read_text()
        if 'kind: "github-archive"' not in text:
            continue
        if re.search(r"enabled:\s*cfg\s*=>\s*cfg\.windows\b", text):
            continue

        symbol = re.search(r"export const (\w+): Dependency", text)
        name = re.search(r'name:\s*"([^"]+)"', text)
        repository = re.search(r'repo:\s*"([^"]+)"', text)
        commit = re.search(r"commit:\s*([^,\n]+)", text)
        if None in {symbol, name, repository, commit}:
            raise RuntimeError(f"Cannot parse GitHub dependency in {path}")

        revision = resolve_constant(text, commit.group(1), path)
        dependencies[symbol.group(1)] = Download(
            name.group(1),
            f"https://github.com/{repository.group(1)}/archive/{revision}.tar.gz",
        )

    index = (dependency_directory / "index.ts").read_text()
    block = re.search(
        r"export const allDeps:[^=]+?=\s*\[(.*?)\];",
        index,
        re.DOTALL,
    )
    if block is None:
        raise RuntimeError("Cannot parse scripts/build/deps/index.ts")
    without_comments = re.sub(r"//.*", "", block.group(1))
    order = re.findall(r"^\s*(\w+)\s*,", without_comments, re.MULTILINE)
    downloads = [dependencies[symbol] for symbol in order if symbol in dependencies]

    node_headers = (dependency_directory / "nodejs-headers.ts").read_text()
    node_version = resolve_constant(
        node_headers, "NODEJS_VERSION", dependency_directory
    )
    downloads.append(
        Download(
            "nodejs-headers",
            f"https://nodejs.org/dist/v{node_version}/node-v{node_version}-headers.tar.gz",
        )
    )
    return downloads


def render_sources(downloads: list[Download]) -> str:
    entries = []
    for download in downloads:
        entries.append(
            f'''  (download "{download.name}"
    "{download.url}"
    "{download.hash}"
  )'''
        )
    return (
        """{ fetchurl }:

# Bun's URL-keyed cache consumes the original archives. fetchFromGitHub would
# unpack them, so keep these inputs as separate fetchurl derivations.
let
  download =
    name: url: hash:
    fetchurl {
      inherit url hash;
      name = "bun-${name}.tar.gz";
    };
in
[
"""
        + "\n".join(entries)
        + "\n]\n"
    )


def webkit_values(source: Path, *, force: bool) -> tuple[str, str]:
    source_text = (source / "scripts" / "build" / "deps" / "webkit.ts").read_text()
    revision_match = re.search(r'export const WEBKIT_VERSION = "([^"]+)";', source_text)
    if revision_match is None:
        raise RuntimeError("Cannot find WEBKIT_VERSION")
    revision = revision_match.group(1)

    webkit_text = WEBKIT.read_text()
    current_revision = re.search(r'^  rev = "([^"]+)";$', webkit_text, re.MULTILINE)
    current_hash = re.search(r'^  hash = "([^"]+)";$', webkit_text, re.MULTILINE)
    if current_revision is None or current_hash is None:
        raise RuntimeError("Cannot parse webkit.nix")
    if revision == current_revision.group(1) and not force:
        return revision, current_hash.group(1)

    sparse_block = re.search(r"sparseCheckout\s*=\s*\[(.*?)\];", webkit_text, re.DOTALL)
    if sparse_block is None:
        raise RuntimeError("Cannot parse WebKit sparse checkout paths")
    sparse_paths = re.findall(r'"([^"]+)"', sparse_block.group(1))
    payload = json.loads(
        run(
            [
                "nix-prefetch-git",
                "--quiet",
                "--url",
                WEBKIT_REPOSITORY,
                "--rev",
                revision,
                "--name",
                "bun-webkit-source",
                "--sparse-checkout",
                "\n".join(sparse_paths),
            ]
        ).stdout
    )
    hash_value = payload.get("hash") or payload.get("sha256")
    if not isinstance(hash_value, str):
        raise TypeError("nix-prefetch-git returned no hash")
    return revision, hash_value


def cargo_hash(version: str, source: Path) -> str:
    expression = f"""
let
  pkgs = import (builtins.toPath {json.dumps(str(ROOT))}) {{
    system = "x86_64-linux";
  }};
in
pkgs.rustPlatform.fetchCargoVendor {{
  pname = "bun-cargo-deps";
  version = {json.dumps(version)};
  src = builtins.storePath {json.dumps(str(source))};
  hash = {json.dumps(FAKE_HASH)};
}}
"""
    result = run(
        ["nix", "build", "--impure", "--no-link", "--expr", expression],
        check=False,
    )
    output = result.stdout + result.stderr
    match = re.search(r"got:\s+(sha256-[A-Za-z0-9+/=]+)", output)
    if match is None:
        raise RuntimeError(f"Cannot determine Cargo vendor hash:\n{output}")
    return match.group(1)


def bootstrap_path(version: str, asset_hash: str) -> Path:
    asset = BOOTSTRAP_ASSETS["x86_64-linux"]
    url = f"https://github.com/oven-sh/bun/releases/download/bun-v{version}/{asset}.zip"
    expression = f"""
let
  pkgs = import (builtins.toPath {json.dumps(str(ROOT))}) {{
    system = "x86_64-linux";
  }};
in
pkgs.stdenvNoCC.mkDerivation {{
  pname = "bun-update-bootstrap";
  version = {json.dumps(version)};
  src = pkgs.fetchurl {{
    url = {json.dumps(url)};
    hash = {json.dumps(asset_hash)};
  }};
  sourceRoot = {json.dumps(asset)};
  nativeBuildInputs = [ pkgs.unzip pkgs.autoPatchelfHook ];
  buildInputs = [ pkgs.openssl pkgs.stdenv.cc.cc.lib ];
  installPhase = ''
    install -Dm755 bun "$out/bin/bun"
  '';
}}
"""
    result = run(
        [
            "nix",
            "build",
            "--impure",
            "--no-link",
            "--print-out-paths",
            "--expr",
            expression,
        ]
    )
    return Path(result.stdout.strip())


def node_modules_hashes(source: Path, bootstrap: Path) -> dict[str, str]:
    hashes: dict[str, str] = {}
    with tempfile.TemporaryDirectory(prefix="bun-update-node-modules-") as temp:
        temporary = Path(temp)

        for platform, (operating_system, cpu) in NODE_MODULE_TARGETS.items():
            cache = temporary / f"cache-{platform}"
            cache.mkdir()
            package_source = temporary / platform
            run(["cp", "-R", "--reflink=auto", str(source), str(package_source)])
            run(["chmod", "-R", "u+w", str(package_source)])

            environment = os.environ.copy()
            environment.update(
                {
                    "BUN_INSTALL_CACHE_DIR": str(cache),
                    "HOME": str(temporary / f"home-{platform}"),
                }
            )
            Path(environment["HOME"]).mkdir()
            for directory in (".", "packages/bun-error", "src/node-fallbacks"):
                run(
                    [
                        str(bootstrap / "bin" / "bun"),
                        "install",
                        "--frozen-lockfile",
                        f"--os={operating_system}",
                        f"--cpu={cpu}",
                    ],
                    cwd=package_source / directory,
                    env=environment,
                )

            output = temporary / f"output-{platform}"
            output.mkdir()
            run(
                [
                    "cp",
                    "-R",
                    "--parents",
                    "node_modules",
                    "packages/bun-error/node_modules",
                    "src/node-fallbacks/node_modules",
                    str(output),
                ],
                cwd=package_source,
            )
            hashes[platform] = run(["nix", "hash", "path", str(output)]).stdout.strip()
    return hashes


def update_package(
    version: str,
    revision: str,
    source_hash: str,
    bootstrap_hashes: dict[str, str],
    node_hashes: dict[str, str],
    vendor_hash: str,
) -> None:
    text = PACKAGE.read_text()
    text = replace_once(
        text,
        r'^  version = "[^"]+";$',
        f'  version = "{version}";',
        flags=re.MULTILINE,
    )
    text = replace_once(
        text,
        r'^  revision = "[^"]+";$',
        f'  revision = "{revision}";',
        flags=re.MULTILINE,
    )
    text = replace_once(
        text,
        r'(src\s*=\s*fetchFromGitHub\s*\{.*?\bhash\s*=\s*")[^"]+',
        rf"\g<1>{source_hash}",
        flags=re.DOTALL,
    )
    for platform, hash_value in bootstrap_hashes.items():
        text = replace_once(
            text,
            rf'("{re.escape(platform)}"\s*=\s*\{{.*?\bhash\s*=\s*")[^"]+',
            rf"\g<1>{hash_value}",
            flags=re.DOTALL,
        )
    for platform, hash_value in node_hashes.items():
        text = replace_once(
            text,
            rf'("{re.escape(platform)}"\s*=\s*")[^"]+(";)',
            rf"\g<1>{hash_value}\g<2>",
        )
    text = replace_once(
        text,
        r'(cargoDeps\s*=\s*rustPlatform\.fetchCargoVendor\s*\{.*?\bhash\s*=\s*")[^"]+',
        rf"\g<1>{vendor_hash}",
        flags=re.DOTALL,
    )
    text = replace_once(
        text,
        r"# Bun [^\n]+ accepts only LLVM 21\.1\.x\.",
        f"# Bun {version} accepts only LLVM 21.1.x.",
    )
    PACKAGE.write_text(text)


def update_webkit(revision: str, hash_value: str) -> None:
    text = WEBKIT.read_text()
    text = replace_once(
        text,
        r'^  rev = "[^"]+";$',
        f'  rev = "{revision}";',
        flags=re.MULTILINE,
    )
    text = replace_once(
        text,
        r'^  hash = "[^"]+";$',
        f'  hash = "{hash_value}";',
        flags=re.MULTILINE,
    )
    WEBKIT.write_text(text)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", help="Update to this stable Bun version")
    parser.add_argument(
        "--force",
        action="store_true",
        help="Regenerate hashes even when the requested version is current",
    )
    arguments = parser.parse_args()

    current = current_version()
    tags = release_tags()
    target = arguments.version or max(tags, key=version_key)
    if target not in tags:
        raise RuntimeError(f"Bun release bun-v{target} does not exist")
    if target == current and not arguments.force:
        print(f"Bun {current} is already up to date")
        return

    source_hash, source = prefetch_file(
        f"https://github.com/oven-sh/bun/archive/{tags[target]}.tar.gz",
        unpack=True,
    )
    validate_llvm_version(source)
    downloads = prefetch_downloads(source_downloads(source))

    bootstrap_downloads = [
        Download(
            platform,
            f"https://github.com/oven-sh/bun/releases/download/bun-v{target}/{asset}.zip",
        )
        for platform, asset in BOOTSTRAP_ASSETS.items()
    ]
    bootstrap_hashes = {
        download.name: download.hash
        for download in prefetch_downloads(bootstrap_downloads)
    }

    webkit_revision, webkit_hash = webkit_values(source, force=arguments.force)

    current_vendor_hash = re.search(
        r'cargoDeps\s*=\s*rustPlatform\.fetchCargoVendor\s*\{.*?\bhash\s*=\s*"([^"]+)"',
        PACKAGE.read_text(),
        re.DOTALL,
    )
    if current_vendor_hash is None:
        raise RuntimeError("Cannot find the current Cargo vendor hash")
    vendor_hash = (
        current_vendor_hash.group(1)
        if target == current and not arguments.force
        else cargo_hash(target, source)
    )

    bootstrap = bootstrap_path(target, bootstrap_hashes["x86_64-linux"])
    node_hashes = node_modules_hashes(source, bootstrap)

    update_package(
        target,
        tags[target],
        source_hash,
        bootstrap_hashes,
        node_hashes,
        vendor_hash,
    )
    SOURCES.write_text(render_sources(downloads))
    update_webkit(webkit_revision, webkit_hash)

    run(["nixfmt", str(PACKAGE), str(SOURCES), str(WEBKIT)])


if __name__ == "__main__":
    main()
