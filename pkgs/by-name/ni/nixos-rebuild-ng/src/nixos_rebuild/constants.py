from typing import Final

# These are replaced in a patch for the actual derivation; what's below supports running the tool
# out of the Nixpkgs repository directly.
EXECUTABLE: Final[str] = "nixos-rebuild-ng"
WITH_REEXEC: Final[bool] = True
WITH_SHELL_FILES: Final[bool] = True
