#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.xmltodict python3.pkgs.requests nurl
import argparse
import json

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionFetcher
from jetbrains_nix_updater.ides import get_single_ide, get_all_ides
from jetbrains_nix_updater.update_bin import run_bin_update
from jetbrains_nix_updater.update_src import run_src_update


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "ide",
        nargs="?",
        help="pname of the IDE to update. If not set, uses UPDATE_NIX_PNAME. "
        "If that is also not set, all IDEs are updated",
    )
    parser.add_argument(
        "--nixpkgs-root", help="root directory of nixpkgs, auto-detected if not given"
    )
    parser.add_argument(
        "--no-bin", action="store_true", help="do not update binary IDEs"
    )
    parser.add_argument(
        "--no-src", action="store_true", help="do not update source IDEs"
    )
    parser.add_argument(
        "--no-maven-deps",
        action="store_true",
        help="do not update maven dependencies for source IDEs",
    )
    parser.add_argument(
        "--old-version",
        type=str,
        help="old version of the IDE, only used if `ide` (or UPDATE_NIX_PNAME) is also used. "
        "Defaults to UPDATE_NIX_OLD_VERSION. If the new version matches the old version, "
        "exits early without making changes.",
    )

    config = UpdaterConfig(parser.parse_args())
    print(f"[i] running jetbrains updater with: {config}")

    with open(config.jetbrains_root / "updater" / "updateInfo.json", "r") as f:
        update_info = json.load(f)
    version_fetcher = VersionFetcher()

    ides_to_run_for = (
        [get_single_ide(update_info, config.jetbrains_root, config.ide)]
        if config.ide is not None
        else list(get_all_ides(update_info, config.jetbrains_root))
    )

    print(f"[.] found IDEs to update: {', '.join(ide.name for ide in ides_to_run_for)}")
    for ide in ides_to_run_for:
        if ide.is_source and config.no_src:
            print(f"[!] skipping {ide.name}, due to --no-src")
            continue
        if not ide.is_source and config.no_bin:
            print(f"[!] skipping {ide.name}, due to --no-bin")
            continue

        print(f"[@] updating IDE {ide.name}")

        info = version_fetcher.latest_version_info(
            ide, ignore_no_url_error=ide.is_source
        )
        if info is not None:
            if config.old_version == info.version:
                print("[o] Version is the same, no update required")
                return

            if ide.is_source:
                run_src_update(ide, info, config)
            else:
                run_bin_update(ide, info, config)


if __name__ == "__main__":
    main()
