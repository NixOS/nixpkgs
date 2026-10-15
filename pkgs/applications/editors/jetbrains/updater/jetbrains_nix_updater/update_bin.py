import sys

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import UpdateScriptBlockException, replace_blocks


def run_bin_update(ide: Ide, info: VersionInfo, config: UpdaterConfig) -> bool:
    urls_nix = ""
    for system, url in info.urls.items():
        urls_nix += f"""
        {system} = {{
          url = "{url.url}";
          hash = "{url.sri_hash}";
        }};"""

    try:
        replace_blocks(
            config,
            ide.drv_path,
            [
                (
                    "version",
                    f"""
                        version = "{info.version}";
                        buildNumber = "{info.build_number}";
                    """,
                ),
                (
                    "urls",
                    f"""
                        urls = {{{urls_nix}}};
                    """,
                ),
            ],
        )
        return True
    except UpdateScriptBlockException as e:
        print(f"[!] Writing update info to file failed: {e}", file=sys.stderr)
        return False
