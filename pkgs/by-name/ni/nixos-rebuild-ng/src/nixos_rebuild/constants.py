# Build-time flags
# Strings to avoid breaking standalone (e.g.: `python -m nixos_rebuild`) usage
EXECUTABLE = "@executable@"
WITH_NIX_2_18 = "@withNix218@" == "true"  # type: ignore
WITH_REEXEC = "@withReexec@" == "true"  # type: ignore
WITH_SHELL_FILES = "@withShellFiles@" == "true"  # type: ignore
