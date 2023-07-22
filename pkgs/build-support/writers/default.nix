{ pkgs, config, lib }:

let
  aliases = if config.allowAliases then (import ./aliases.nix lib) else prev: {};

  scriptWriters = import ./scripts.nix { inherit pkgs lib; };

  writers = scriptWriters;
in
writers // (aliases writers)
