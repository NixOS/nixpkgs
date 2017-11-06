{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nixpkgs;


  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  # for NIXOS (nixos-rebuild): use nixpkgs.config option
  nixpkgs_config =
    let
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      configExpr =
        if configFile != "" && pathExists configFile then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
        else {};

    in
      # allow both:
      # { /* the config */ } and
      # { pkgs, ... } : { /* the config */ }
      if builtins.isFunction configExpr
        then configExpr { inherit pkgs; }
        else configExpr;

in

{
  options = {

    nixpkgs.includeLegacyConfig = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Merge legacy nixpkgs configuration from "~/.nixpkgs/config.nix"
        into the "nixpkgs.config" option.
        NOTE: The option will default to "false" after a transition period.
              So move your configuration from "~/.nixpkgs/config.nix" into
              "$XDG_CONFIG_HOME/nixup/profile.nix" under the "nixpkgs.config" option.
      '';
    };

  };

  config = {

    nixpkgs.config = mkIf cfg.includeLegacyConfig nixpkgs_config;

  };
}
