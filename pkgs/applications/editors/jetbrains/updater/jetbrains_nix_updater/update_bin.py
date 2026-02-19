from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import replace_blocks, convert_hash_to_sri


def run_bin_update(ide: Ide, info: VersionInfo, config: UpdaterConfig):
    urls_nix = ""
    for system, url in info.urls.items():
        urls_nix += f"""
        {system} = {{
          url = "{url}";
          hash = "{convert_hash_to_sri(info.download_sha256(system))}";
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
    except Exception as e:
        print(f"[!] Writing update info to file failed: {e}")
