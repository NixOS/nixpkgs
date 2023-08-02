{ config, lib, callPackages }:

let
  aliases = if config.allowAliases then (import ./aliases.nix lib) else prev: {};

  # Writers for JSON-like data structures
  dataWriters = callPackages ./data.nix { };

  # Writers for scripts
  scriptWriters = callPackages ./scripts.nix { };

  writers = scriptWriters // dataWriters;
in
writers // (aliases writers)
