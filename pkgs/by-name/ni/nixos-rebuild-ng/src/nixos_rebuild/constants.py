from typing import Final

# These are replaced in a patch for the actual derivation; what's below supports running the tool
# out of the Nixpkgs repository directly.
EXECUTABLE: Final[str] = "nixos-rebuild-ng"
WITH_REEXEC: Final[bool] = True

# These names are replaced with absolute paths to Nix in the store.
NIX: Final[str] = "nix"
NIX_BUILD: Final[str] = "nix-build"
NIX_CHANNEL: Final[str] = "nix-channel"
NIX_COPY_CLOSURE: Final[str] = "nix-copy-closure"
NIX_ENV: Final[str] = "nix-env"
NIX_INSTANTIATE: Final[str] = "nix-instantiate"
NIX_STORE: Final[str] = "nix-store"
