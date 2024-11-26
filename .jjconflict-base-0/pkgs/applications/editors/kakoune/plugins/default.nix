{
  callPackage,
  config,
  kakouneUtils,
  lib,
}:

let

  inherit (kakouneUtils.override { }) buildKakounePluginFrom2Nix;

  plugins = callPackage ./generated.nix {
    inherit buildKakounePluginFrom2Nix overrides;
  };

  # TL;DR
  # * Add your plugin to ./kakoune-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit buildKakounePluginFrom2Nix;
  };

  aliases = lib.optionalAttrs config.allowAliases (import ./aliases.nix lib plugins);

in

plugins // aliases
