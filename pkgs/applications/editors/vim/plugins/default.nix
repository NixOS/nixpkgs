# TODO check that no license information gets lost
{
  callPackage,
  config,
  lib,
  vimUtils,
  vim,
  llvmPackages,
  neovimUtils,
}:

let

  inherit (vimUtils.override { inherit vim; })
    buildVimPlugin
    ;

  inherit (lib) extends;

  plugins = callPackage ./parse-generated.nix {
    inherit buildVimPlugin;
  };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit buildVimPlugin;
    inherit llvmPackages;
  };

  aliases = if config.allowAliases then (import ./aliases.nix lib) else final: prev: { };

  extensible-self = lib.makeExtensible (extends aliases (extends overrides (lib.toFunction plugins)));
in
extensible-self
