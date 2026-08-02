final: prev: {
  compiz-bcop = prev.callPackage ../packages/compiz-reloaded/compiz-bcop.nix { };
  compiz-core = prev.callPackage ../packages/compiz-reloaded/compiz-core.nix { };
  compiz-plugins-main = prev.callPackage ../packages/compiz-reloaded/compiz-plugins-main.nix { };
  compiz-plugins-extra = prev.callPackage ../packages/compiz-reloaded/compiz-plugins-extra.nix { };
  compiz-plugins-experimental = prev.callPackage ../packages/compiz-reloaded/compiz-plugins-experimental.nix { };
  libcompizconfig = prev.callPackage ../packages/compiz-reloaded/libcompizconfig.nix { };
  compizconfig-python = prev.callPackage ../packages/compiz-reloaded/compizconfig-python.nix { };
  ccsm = prev.callPackage ../packages/compiz-reloaded/ccsm.nix { };
  simple-ccsm = prev.callPackage ../packages/compiz-reloaded/simple-ccsm.nix { };
  emerald = prev.callPackage ../packages/compiz-reloaded/emerald.nix { };
  emerald-themes = prev.callPackage ../packages/compiz-reloaded/emerald-themes.nix { };
  fusion-icon = prev.callPackage ../packages/compiz-reloaded/fusion-icon.nix { };
  compiz-manager = prev.callPackage ../packages/compiz-reloaded/compiz-manager.nix { };

  euclid-icon-theme = prev.callPackage ../packages/euclid-icon-theme { };
  euclid-wallpapers = prev.callPackage ../packages/euclid-wallpapers { };
  euclid-welcome = prev.callPackage ../packages/euclid-welcome { };
} // (import ./lumina.nix final prev)
