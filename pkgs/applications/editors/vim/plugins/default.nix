# TODO check that no license information gets lost
{ callPackage, config, lib, vimUtils, vim, darwin, llvmPackages
, neovim-unwrapped
, neovimUtils
, neovim
, luaPackages
}:

let

  inherit (vimUtils.override {inherit vim;})
    buildVimPlugin;

  inherit (lib) extends;

  initialPackages = self: { };

  plugins = callPackage ./generated.nix {
    inherit buildVimPlugin;
    inherit (neovimUtils) buildNeovimPlugin;
  };

  # neovim plugins that are generated via the
  # pkgs/applications/editors/neovim/generated-plugins.nix
  neovimPlugins =  callPackage ../../neovim/generated-plugins.nix {
    inherit buildVimPlugin;
    # callPackage = neovim.lua.pkgs.callPackage;
    callPackage = neovim.passthru.unwrapped.lua.pkgs.callPackage;
    inherit (neovimUtils) buildNeovimPlugin;
  };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreFoundation CoreServices;
    inherit buildVimPlugin;
    inherit llvmPackages;
  };

  aliases = if config.allowAliases then (import ./aliases.nix lib) else final: prev: {};

  extensible-self = lib.makeExtensible
    (extends aliases
      (extends overrides
        # plugins
        (extends neovimPlugins
          (extends plugins initialPackages)
        )
      )
    );
in
  extensible-self
