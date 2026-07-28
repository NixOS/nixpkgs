# mypy: disable-error-code=comparison-overlap
import os
from typing import Final

# Build-time flags
# Use strings to avoid breaking standalone (e.g.: `python -m nixos_rebuild`)
# usage
EXECUTABLE: Final[str] = "@executable@"
# Use either `== "true"` if the default (e.g.: `python -m nixos_rebuild`) is
# `False` or `!= "false"` if the default is `True`
WITH_SHELL_FILES: Final[bool] = "@withShellFiles@" == "true"
# Whether using nix-output-monitor for builds is enabled: the
# NIXOS_REBUILD_USE_NOM environment variable if set (empty and "0" meaning
# false), the build-time flag otherwise
USE_NOM: Final[bool] = (
    env not in ("", "0")
    if (env := os.environ.get("NIXOS_REBUILD_USE_NOM")) is not None
    else "@useNom@" == "true"
)
