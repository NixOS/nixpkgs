#!@pythonInterpreter@
# slightly tweaked from the script created by @lionirdeadman
# https://github.com/flathub/com.discordapp.Discord/blob/master/disable-breaking-updates.py
"""
Disable breaking updates which will prompt users to download a deb or tar file
and lock them out of Discord making the program unusable.

This will dramatically improve the experience :

 1) The maintainer doesn't need to be worried at all times of an update which will break Discord.
 2) People will not be locked out of the program while the maintainer runs to update it.

"""

import json
import os
import sys
from pathlib import Path

config_home = {
    "darwin": os.path.join(os.path.expanduser("~"), "Library", "Application Support"),
    "linux": os.environ.get("XDG_CONFIG_HOME") or os.path.join(os.path.expanduser("~"), ".config")
}.get(sys.platform, None)

if config_home is None:
    print("[Nix] Unsupported operating system.")
    sys.exit(1)

config_dir_name = "@configDirName@".replace(" ", "") if sys.platform == "darwin" else "@configDirName@"

settings_path = Path(f"{config_home}/{config_dir_name}/settings.json")
settings_path_temp = Path(f"{config_home}/{config_dir_name}/settings.json.tmp")

if os.path.exists(settings_path):
    with settings_path.open(encoding="utf-8") as settings_file:
        try:
            settings = json.load(settings_file)
        except json.JSONDecodeError:
            print("[Nix] settings.json is malformed, letting Discord fix itself")
            sys.exit(0)
else:
    settings = {}

required_settings = {"SKIP_HOST_UPDATE": True}
if "@skipModuleUpdate@" == "true":
    required_settings["SKIP_MODULE_UPDATE"] = True

missing_settings = {
    key: value for key, value in required_settings.items() if settings.get(key) != value
}

if missing_settings:
    settings.update(missing_settings)

    os.makedirs(os.path.dirname(settings_path), exist_ok=True)

    with settings_path_temp.open("w", encoding="utf-8") as settings_file_temp:
        json.dump(settings, settings_file_temp, indent=2)

    settings_path_temp.rename(settings_path)
    print("[Nix] Disabled updates")
else:
    print("[Nix] Disabling updates already done")
