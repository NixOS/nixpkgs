import json
import re
import sys
from pathlib import Path
from subprocess import CalledProcessError

from xmltodict import parse

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.update_src_maven import (
    ensure_is_list,
    get_maven_deps_for_ide,
)
from jetbrains_nix_updater.util import convert_hash_to_sri, run_command


class InvalidMetadataException(Exception):
    "raised when required metadata is invalid or malformed."


def jar_repositories(root_path: Path) -> list[str]:
    repositories = []
    with open(root_path / ".idea" / "jarRepositories.xml") as f:
        file_contents = parse(f.read())
    component = file_contents["project"]["component"]
    if component["@name"] != "RemoteRepositoriesConfiguration":
        return repositories
    options = component["remote-repository"]
    for option in ensure_is_list(options):
        for item in option["option"]:
            if item["@name"] == "url":
                repositories.append(
                    # Remove protocol and cache-redirector server, we only want the original URL. We try both the original
                    # URL and the URL via the cache-redirector for download in build.nix
                    re.sub(r"^https?://", "", item["@value"]).removeprefix(
                        "cache-redirector.jetbrains.com/"
                    )
                )

    return repositories


def kotlin_jps_plugin_info(root_path: Path) -> tuple[str, str]:
    with open(root_path / ".idea" / "kotlinc.xml") as f:
        file_contents = parse(f.read())
    components = file_contents["project"]["component"]
    for component in components:
        if component["@name"] != "KotlinJpsPluginSettings":
            continue

        option = component["option"]
        version = option["@value"]

        print(f"[*] Prefetching Kotlin JPS Plugin version {version}...")
        prefetch = run_command(
            [
                "nix-prefetch-url",
                "--type",
                "sha256",
                f"https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/kotlin/kotlin-jps-plugin-classpath/{version}/kotlin-jps-plugin-classpath-{version}.jar",
            ]
        )

        return (version, convert_hash_to_sri(prefetch))
    raise InvalidMetadataException(
        "No KotlinJpsPluginSettings component in kotlinc.xml"
    )


def requested_kotlinc_version(root_path: Path) -> str:
    with open(root_path / ".idea" / "kotlinc.xml") as f:
        file_contents = parse(f.read())
    components = file_contents["project"]["component"]
    for component in components:
        if component["@name"] != "KotlinJpsPluginSettings":
            continue

        option = component["option"]
        version = option["@value"]

        return version
    raise InvalidMetadataException(
        "No KotlinJpsPluginSettings component in kotlinc.xml"
    )


def prefetch_intellij_community(variant: str, version: str) -> tuple[str, Path]:
    print("[*] Prefetching IntelliJ community source code...")
    prefetch = run_command(
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

    hash = convert_hash_to_sri(parts[0])
    out_path = parts[1]

    return (hash, Path(out_path))


def prefetch_android(variant: str, version: str) -> str:
    print("[*] Prefetching Android plugin source code...")
    prefetch = run_command(
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
    return convert_hash_to_sri(prefetch)


def generate_restarter_hash(config: UpdaterConfig, root_path: Path) -> str:
    print("[*] Generating restarter Cargo hash...")
    root_name = root_path.name
    return run_command(
        [
            "nurl",
            "--expr",
            f'''
        (import {config.nixpkgs_root} {{}}).rustPlatform.buildRustPackage {{
            name = "restarter";
            src = {root_path};
            sourceRoot = "{root_name}/native/restarter";
            cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}
    ''',
        ]
    )


def generate_jps_hash(config: UpdaterConfig, root_path: Path) -> str:
    print("[*] Generating jps repo hash...")
    jps_repo_nix = config.jetbrains_root / "source" / "jps_repo.nix"
    return run_command(
        [
            "nurl",
            "--expr",
            f"""
        (import {config.nixpkgs_root} {{}}).callPackage {jps_repo_nix} {{
            jbr = (import {config.nixpkgs_root} {{}}).jetbrains.jdk-no-jcef;
            src = {root_path};
            jpsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }}
    """,
        ]
    )


def run_src_update(ide: Ide, info: VersionInfo, config: UpdaterConfig) -> bool:
    variant = ide.name.removesuffix("-oss")
    if variant.endswith("idea"):
        variant = variant.removeprefix("intellij-")

    try:
        intellij_hash, intellij_outpath = prefetch_intellij_community(
            variant, info.version
        )
        android_hash = prefetch_android(variant, info.version)
    except CalledProcessError:
        print(
            f"[!] Unable to fetch sources for version {info.version}. "
            f"This probably means, that JetBrains has not published a source release yet for this version. "
            f"Check: https://github.com/JetBrains/intellij-community/releases and https://github.com/JetBrains/android/tags",
            file=sys.stderr,
        )
        print(f"[!] Skipping update of {ide.name}.", file=sys.stderr)
        return False
    jps_hash = generate_jps_hash(config, intellij_outpath)
    restarter_hash = generate_restarter_hash(config, intellij_outpath)
    repositories = jar_repositories(intellij_outpath)
    kjps_plugin_version, kjps_plugin_hash = kotlin_jps_plugin_info(intellij_outpath)
    kotlinc_version = requested_kotlinc_version(intellij_outpath)
    print(
        f"[i] Prefetched IDEA Open Source requested Kotlin compiler {kotlinc_version}"
    )

    source_args_path = ide.package_dir / "source_args.json"
    source_args = {
        "version": info.version,
        "buildNumber": info.build_number,
        "buildType": variant,
        "ideaHash": intellij_hash,
        "androidHash": android_hash,
        "jpsHash": jps_hash,
        "restarterHash": restarter_hash,
        "repositories": repositories,
        "kotlin-jps-plugin": {
            "version": kjps_plugin_version,
            "hash": kjps_plugin_hash,
        },
    }

    print(f"[*] Writing mkJetBrainsSource args to {source_args_path}")
    if not config.dry_run:
        with source_args_path.open("w") as f:
            json.dump(source_args, f, indent=2)
            f.write("\n")

    if not config.no_maven_deps:
        print("[*] Collecting maven hashes")
        maven_hashes = get_maven_deps_for_ide(config, ide)
        maven_out_path = ide.package_dir / "maven_artefacts.json"
        if config.dry_run:
            assert maven_out_path.parent.exists()
            print(f"[D] --dry-run: {maven_out_path} not modified", file=sys.stderr)
        else:
            with maven_out_path.open("w") as f:
                json.dump(maven_hashes, f, indent=4)
                f.write("\n")
    return True
