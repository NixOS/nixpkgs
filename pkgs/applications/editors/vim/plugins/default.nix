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

  cocPlugins = callPackage ./cocPlugins.nix {
    inherit buildVimPlugin;
  };

  luaPackagePlugins = callPackage ./luaPackagePlugins.nix {
    inherit (neovimUtils) buildNeovimPlugin;
  };

  nodePackagePlugins = callPackage ./nodePackagePlugins.nix {
    inherit buildVimPlugin;
  };

  nonGeneratedPlugins =
    self: super:
    let
      root = ./non-generated;
      call = name: callPackage (root + "/${name}") { };
    in
    lib.pipe root [
      builtins.readDir
      (lib.filterAttrs (_: type: type == "directory"))
      (builtins.mapAttrs (name: _: call name))
    ];

  plugins = callPackage ./generated.nix {
    inherit buildVimPlugin;
    inherit (neovimUtils) buildNeovimPlugin;
  };

  corePlugins = callPackage ./corePlugins.nix { };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit llvmPackages;
  };

  aliases = if config.allowAliases then (import ./aliases.nix lib) else final: prev: { };
in
lib.pipe initialPackages [
  (extends plugins)
  (extends cocPlugins)
  (extends luaPackagePlugins)
  (extends nodePackagePlugins)
  (extends nonGeneratedPlugins)
  (extends corePlugins)
  (extends overrides)
  (extends aliases)
  lib.makeExtensible
]
