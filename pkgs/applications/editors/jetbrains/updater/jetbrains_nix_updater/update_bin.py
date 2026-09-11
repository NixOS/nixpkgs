import json

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.fetcher import VersionInfo
from jetbrains_nix_updater.ides import Ide


def run_bin_update(ide: Ide, info: VersionInfo, config: UpdaterConfig) -> bool:
    version_info_path = ide.package_dir / "version.json"
    version_info = {
        "version": info.version,
        "buildNumber": info.build_number,
        "urls": {
            system: {"url": url.url, "hash": url.sri_hash}
            for system, url in info.urls.items()
            if url
        },
    }

    if not config.dry_run:
        with version_info_path.open("w") as f:
            json.dump(version_info, f, indent=2)
            f.write("\n")
    return True
