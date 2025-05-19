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
  # deprecated, but added first so it can be overriden by normal `plugins`
  # see https://github.com/NixOS/nixpkgs/issues/407318
  (extends luaPackagePlugins)
  (extends plugins)
  (extends cocPlugins)
  (extends nodePackagePlugins)
  (extends nonGeneratedPlugins)
  (extends overrides)
  (extends aliases)
  # deprecated, but added last so it only adds them if they haven't been set
  # before. If you get a warning, add the missing plugin to `vim-plugin-names`
  #
  # see https://github.com/NixOS/nixpkgs/issues/407318
  (extends luaPackagePlugins)
  lib.makeExtensible
]
