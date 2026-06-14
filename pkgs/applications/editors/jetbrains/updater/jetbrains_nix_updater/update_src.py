import sys

from pathlib import Path

import asyncio
import platform
from dataclasses import dataclass
from glob import glob
from subprocess import CalledProcessError

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import replace_blocks, run_command, convert_hash_to_sri


async def prefetch_intellij_community(variant: str, version: str) -> tuple[str, Path]:
    print("[*] Prefetching IntelliJ community source code...")
    prefetch = await run_command(
        [
            "nix-prefetch-url",
            "--print-path",
            "--unpack",
            "--name",
            "source",
            "--type",
            "sha256",
            f"https://github.com/jetbrains/intellij-community/archive/{variant}/{version}.tar.gz",
        ]
    )
    parts = prefetch.split()

    hash = await convert_hash_to_sri(parts[0])
    out_path = parts[1]

    return hash, Path(out_path)


async def prefetch_android(variant: str, version: str) -> str:
    print("[*] Prefetching Android plugin source code...")
    prefetch = await run_command(
        [
            "nix-prefetch-url",
            "--unpack",
            "--name",
            "source",
            "--type",
            "sha256",
            f"https://github.com/jetbrains/android/archive/{variant}/{version}.tar.gz",
        ]
    )
    return await convert_hash_to_sri(prefetch)


async def generate_restarter_hash(config: UpdaterConfig, ij_root_path: Path) -> str:
    print("[*] Generating restarter Cargo hash...")
    root_name = ij_root_path.name
    return await run_command(
        [
            "nurl",
            "--expr",
            f'''
        (import {config.nixpkgs_root} {{}}).rustPlatform.buildRustPackage {{
            name = "restarter";
            src = {ij_root_path};
            sourceRoot = "{root_name}/native/restarter";
            cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}
    ''',
        ]
    )


def get_bazel_version(ij_root_path: Path) -> tuple[str, str]:
    with open(ij_root_path.joinpath(".bazelversion"), "r") as f:
        version_string = f.read()
    bazel_base_version, bazel_patches_version = version_string.removeprefix(
        "JetBrains/"
    ).split("-", 1)
    print(
        f"[i] Detected Bazel version: {bazel_base_version} - JetBrains patches: {bazel_patches_version}"
    )
    return bazel_base_version, bazel_patches_version


async def prefetch_bazel_src(bazel_base_version: str) -> str:
    print(f"[*] Prefetching Bazel {bazel_base_version} source...")
    prefetch = await run_command(
        [
            "nix-prefetch-url",
            "--unpack",
            "--name",
            "source",
            "--type",
            "sha256",
            f"https://github.com/bazelbuild/bazel/releases/download/{bazel_base_version}/bazel-{bazel_base_version}-dist.zip",
        ]
    )
    return await convert_hash_to_sri(prefetch)


async def prefetch_jb_bazel_patches_src(
    bazel_base_version: str, bazel_patches_version: str
) -> tuple[str, Path]:
    tag = f"{bazel_base_version}-{bazel_patches_version}"
    print(f"[*] Prefetching JetBrains Bazel patches {tag} source...")
    prefetch = await run_command(
        [
            "nix-prefetch-url",
            "--print-path",
            "--unpack",
            "--name",
            "source",
            "--type",
            "sha256",
            f"https://github.com/jetbrains/bazel/archive/{tag}/{tag}.tar.gz",
        ]
    )
    parts = prefetch.split()

    hash = await convert_hash_to_sri(parts[0])
    out_path = parts[1]

    return hash, Path(out_path)


def get_jb_bazel_patches_files(patches_outpath: Path) -> list[str]:
    # These patches are known to cause issues and are not relevant for the build using Nix, so we skip them
    SKIP_PATCHES = ["0015-Allow-platform-specific-startup-bazelrc-flags.patch"]

    patches_dir = patches_outpath.joinpath("patches")
    all_patches = (Path(p) for p in glob(str(patches_dir.joinpath("*.patch"))))
    return sorted([p.name for p in all_patches if p.name not in SKIP_PATCHES])


async def latest_commit_sha(repo_url, ref="main"):
    out = await run_command(["git", "ls-remote", repo_url, ref])
    return out.split()[0]


async def get_latest_bazel_registry() -> tuple[str, str]:
    print(f"[*] Getting latest Bazel repo commit...")
    commit = await latest_commit_sha(
        "https://github.com/bazelbuild/bazel-central-registry"
    )
    print(f"[*] Prefetching Bazel repo commit {commit}...")
    prefetch = await run_command(
        [
            "nix-prefetch-url",
            "--unpack",
            "--name",
            "source",
            "--type",
            "sha256",
            f"https://github.com/bazelbuild/bazel-central-registry/archive/{commit}/{commit}.tar.gz",
        ]
    )
    return commit, await convert_hash_to_sri(prefetch)


@dataclass(slots=True)
class BazelConfig:
    base_version: str
    patches_version: str
    base_hash: str
    patches_hash: str
    patches_names: list[str]
    registry_rev: str
    registry_hash: str


async def get_bazel_config(intellij_outpath: Path) -> BazelConfig:
    base_version, patches_version = get_bazel_version(intellij_outpath)

    (
        base_hash,
        (patches_hash, patches_outpath),
        (registry_rev, registry_hash),
    ) = await asyncio.gather(
        prefetch_bazel_src(base_version),
        prefetch_jb_bazel_patches_src(base_version, patches_version),
        get_latest_bazel_registry(),
    )

    patches_names = get_jb_bazel_patches_files(patches_outpath)
    return BazelConfig(
        base_version=base_version,
        patches_version=patches_version,
        base_hash=base_hash,
        patches_hash=patches_hash,
        patches_names=patches_names,
        registry_rev=registry_rev,
        registry_hash=registry_hash,
    )


async def prebuild_repo_cache(
    config: UpdaterConfig,
    system: str,
    machine: str,
    ide_name: str,
    drv_path: Path,
    placeholder_hash: str,
):
    if system != platform.system() or machine != platform.machine():
        print(
            f"[!] Skipping repoCacheFODHashes generation for {machine}-{system.lower()}: can not build - please update manually."
        )
        return

    print(
        f"[*] Generating repoCacheFODHash for {machine}-{system.lower()}: this can take a long time"
    )
    hash = await run_command(
        [
            "nurl",
            "--expr",
            f'(import {config.nixpkgs_root} {{}}).jetbrains."{ide_name}".src.bazelRepoCache',
        ]
    )

    with open(drv_path, "r") as file:
        drv_content = file.read()
    drv_content = drv_content.replace(placeholder_hash, hash)
    with open(drv_path, "w") as file:
        file.write(drv_content)


async def run_src_update(ide: Ide, info: VersionInfo, config: UpdaterConfig) -> bool:
    variant = ide.name.removesuffix("-oss")
    try:
        intellij_hash, intellij_outpath = await prefetch_intellij_community(
            variant, info.version
        )
    except CalledProcessError:
        print(
            f"[!] Unable to fetch sources for version {info.version}. "
            f"This probably means, that JetBrains has not published a source release yet for this version. "
            f"Check: https://github.com/JetBrains/intellij-community/releases",
            file=sys.stderr,
        )
        print(f"[!] Skipping update of {ide.name}.", file=sys.stderr)
        return False

    android_hash, restarter_hash, bazel_config = await asyncio.gather(
        prefetch_android(variant, info.version),
        generate_restarter_hash(config, intellij_outpath),
        get_bazel_config(intellij_outpath),
    )

    DUMMY_HASH_X86_64_LINUX = f"sha256-{'0' * 43}"

    try:
        await replace_blocks(
            config,
            ide.drv_path,
            [
                (
                    "source-args",
                    f"""
                        version = "{info.version}";
                        buildNumber = "{info.build_number}";
                        buildType = "{variant}";
                        ideaHash = "{intellij_hash}";
                        androidHash = "{android_hash}";
                        restarterHash = "{restarter_hash}";
                        bazelConfig = {{
                            base = {{
                                version = "{bazel_config.base_version}";
                                hash = "{bazel_config.base_hash}";
                            }};
                            jbPatches = {{
                                version = "{bazel_config.patches_version}";
                                hash = "{bazel_config.patches_hash}";
                                names = [
                                    {" ".join(f'"{x}"' for x in bazel_config.patches_names)}
                                ];
                            }};
                            registry = {{
                                rev = "{bazel_config.registry_rev}";
                                hash = "{bazel_config.registry_hash}";
                            }};
                            repoCacheFODHashes = {{
                                x86_64-linux = "{DUMMY_HASH_X86_64_LINUX}";
                            }};
                        }};
                    """,
                )
            ],
        )
    except Exception as e:
        print(f"[!] Writing update info to file failed: {e}", file=sys.stderr)
        return False

    # Refresh vendor FOD hash
    await prebuild_repo_cache(
        config, "Linux", "x86_64", ide.name, ide.drv_path, DUMMY_HASH_X86_64_LINUX
    )

    return True
