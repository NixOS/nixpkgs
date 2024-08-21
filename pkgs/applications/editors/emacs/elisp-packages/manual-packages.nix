{ lib, pkgs }:

self:
let
  inherit (self) callPackage;
in
lib.packagesFromDirectoryRecursive {
  inherit callPackage;
  directory = ./manual-packages;
}
// {
  inherit (pkgs) emacspeak;

  codeium = callPackage ./manual-packages/codeium {
    inherit (pkgs) codeium;
  };

  consult-gh = callPackage ./manual-packages/consult-gh {
    inherit (pkgs) gh;
  };

  lsp-bridge = callPackage ./manual-packages/lsp-bridge {
    inherit (pkgs) basedpyright git go gopls python3;
  };

  matrix-client = callPackage ./manual-packages/matrix-client {
    _map = self.map;
  };

  structured-haskell-mode = self.shm;

  texpresso = callPackage ./manual-packages/texpresso { inherit (pkgs) texpresso; };

  tree-sitter-langs = callPackage ./manual-packages/tree-sitter-langs { final = self; };

  # From old emacsPackages (pre emacsPackagesNg)
  cedille = callPackage ./manual-packages/cedille { inherit (pkgs) cedille; };

  # camelCase aliases for some of the kebab-case expressions above
  colorThemeSolarized = self.color-theme-solarized;
  emacsSessionManagement = self.session-management-for-emacs;
  rectMark = self.rect-mark;
  sunriseCommander = self.sunrise-commander;
}
### Aliases
// lib.optionalAttrs pkgs.config.allowAliases {
  agda-input = throw "emacsPackages.agda-input is contained in emacsPackages.agda2-mode, please use that instead."; # Added 2024-07-17
  ess-R-object-popup = throw "emacsPackages.ess-R-object-popup was deleted, since the upstream repo looks abandoned."; # Added 2024-07-15
  ghc-mod = throw "emacsPackages.ghc-mod was deleted because it is deprecated, use haskell-language-server instead."; # Added 2024-07-17
  haskell-unicode-input-method = throw "emacsPackages.haskell-unicode-input-method is contained in emacsPackages.haskell-mode, please use that instead."; # Added 2024-07-17
  perl-completion = throw "emacsPackages.perl-completion was removed, since it is broken."; # Added 2024-07-19
}
