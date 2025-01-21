# Build-time flags
# Use strings to avoid breaking standalone (e.g.: `python -m nixos_rebuild`)
# usage
EXECUTABLE = "@executable@"
# Use either `== "true"` if the default (e.g.: `python -m nixos_rebuld`) is
# `False` or `!= "false"` if the default is `True`
WITH_NIX_2_18 = "@withNix218@" != "false"  # type: ignore
WITH_REEXEC = "@withReexec@" == "true"  # type: ignore
WITH_SHELL_FILES = "@withShellFiles@" == "true"  # type: ignore
