{ pkgs, config, lib }:

let
  aliases = if config.allowAliases then (import ./aliases.nix lib) else prev: {};

  # Writers for JSON-like data structures
  dataWriters = import ./data.nix {
    inherit lib; inherit (pkgs) runCommandNoCC dasel;
  };

  # Writers for scripts
  scriptWriters = import ./scripts.nix {
    inherit lib pkgs;
  };

  writers = scriptWriters // dataWriters;
in
writers // (aliases writers)
