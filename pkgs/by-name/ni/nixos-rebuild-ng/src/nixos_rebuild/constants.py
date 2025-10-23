from typing import Final

# The name of this executable, for purposes of replacing `nixos-rebuild`.
# The derivation replaces this using a patch file.
EXECUTABLE: Final[str] = "nixos-rebuild-ng"

# These names are replaced with absolute paths to Nix in the store in the derivation.
# Some of these names could be either `nix` or `nom`, and are called out as such.
NIX: Final[str] = "nix"
NIX_OR_NOM: Final[str] = "nix"
NIX_BUILD: Final[str] = "nix-build"
NIX_CHANNEL: Final[str] = "nix-channel"
NIX_COPY_CLOSURE: Final[str] = "nix-copy-closure"
NIX_ENV: Final[str] = "nix-env"
NIX_INSTANTIATE: Final[str] = "nix-instantiate"
NIX_STORE: Final[str] = "nix-store"
