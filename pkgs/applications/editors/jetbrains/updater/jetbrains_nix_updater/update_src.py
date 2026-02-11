import json
import re
from pathlib import Path
from xmltodict import parse

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.update_src_maven import (
    get_maven_deps_for_ide,
    ensure_is_list,
)
from jetbrains_nix_updater.util import replace_blocks, run_command, convert_hash_to_sri


def jar_repositories(root_path: Path) -> list[str]:
    repositories = []
    file_contents = parse(open(root_path / ".idea" / "jarRepositories.xml").read())
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
    file_contents = parse(open(root_path / ".idea" / "kotlinc.xml").read())
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


def requested_kotlinc_version(root_path: Path) -> str:
    file_contents = parse(open(root_path / ".idea" / "kotlinc.xml").read())
    components = file_contents["project"]["component"]
    for component in components:
        if component["@name"] != "KotlinJpsPluginSettings":
            continue

        option = component["option"]
        version = option["@value"]

        return version


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


def maven_out_path(jb_root: Path, name: str) -> Path:
    return jb_root / "source" / f"{name}_maven_artefacts.json"


def run_src_update(ide: Ide, info: VersionInfo, config: UpdaterConfig):
    variant = ide.name.removesuffix("-oss")
    intellij_hash, intellij_outpath = prefetch_intellij_community(variant, info.version)
    android_hash = prefetch_android(variant, info.version)
    jps_hash = generate_jps_hash(config, intellij_outpath)
    restarter_hash = generate_restarter_hash(config, intellij_outpath)
    repositories = jar_repositories(intellij_outpath)
    kjps_plugin_version, kjps_plugin_hash = kotlin_jps_plugin_info(intellij_outpath)
    kotlinc_version = requested_kotlinc_version(intellij_outpath)
    print(
        f"[i] Prefetched IDEA Open Source requested Kotlin compiler {kotlinc_version}"
    )

    repositories_nix = " ".join(f'"{x}"' for x in repositories)

    try:
        replace_blocks(
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
                        jpsHash = "{jps_hash}";
                        restarterHash = "{restarter_hash}";
                        mvnDeps = ../source/{variant}_maven_artefacts.json;
                        repositories = [
                            {repositories_nix}
                        ];
                        kotlin-jps-plugin = {{
                            version = "{kjps_plugin_version}";
                            hash = "{kjps_plugin_hash}";
                        }};
                    """,
                )
            ],
        )
    except Exception as e:
        print(f"[!] Writing update info to file failed: {e}")
        return

    if not config.no_maven_deps:
        print("[*] Collecting maven hashes")
        maven_hashes = get_maven_deps_for_ide(config, ide)
        with open(maven_out_path(config.jetbrains_root, variant), "w") as f:
            json.dump(maven_hashes, f, indent=4)
            f.write("\n")
