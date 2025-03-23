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

  initialPackages = self: { };

  luaPackagePlugins = callPackage ./luaPackagePlugins.nix {
    inherit (neovimUtils) buildNeovimPlugin;
  };

  nodePackagePlugins = callPackage ./nodePackagePlugins.nix {
    inherit buildVimPlugin;
  };

  nonGeneratedPlugins =
    self: super:
    lib.mapAttrs (name: _: callPackage (./non-generated + "/${name}") { }) (
      lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./non-generated)
    );

  plugins = callPackage ./generated.nix {
    inherit buildVimPlugin;
    inherit (neovimUtils) buildNeovimPlugin;
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
in
lib.pipe initialPackages [
  (extends plugins)
  (extends luaPackagePlugins)
  (extends nodePackagePlugins)
  (extends nonGeneratedPlugins)
  (extends overrides)
  (extends aliases)
  lib.makeExtensible
]
