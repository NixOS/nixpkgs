{ lib, pkgs }:

self:
let
  inherit (self) callPackage;
in
{
  acm = callPackage ./manual-packages/acm { };

  acm-terminal = callPackage ./manual-packages/acm-terminal { };

  agda-input = callPackage ./manual-packages/agda-input { };

  agda2-mode = callPackage ./manual-packages/agda2-mode { };

  cask = callPackage ./manual-packages/cask { };

  control-lock = callPackage ./manual-packages/control-lock { };

  ebuild-mode = callPackage ./manual-packages/ebuild-mode { };

  elisp-ffi = callPackage ./manual-packages/elisp-ffi { };

  emacspeak = callPackage ./manual-packages/emacspeak { };

  ess-R-object-popup = callPackage ./manual-packages/ess-R-object-popup { };

  evil-markdown = callPackage ./manual-packages/evil-markdown { };

  font-lock-plus = callPackage ./manual-packages/font-lock-plus { };

  ghc-mod = callPackage ./manual-packages/elisp-ffi { };

  git-undo = callPackage ./manual-packages/git-undo { };

  haskell-unicode-input-method = callPackage ./manual-packages/haskell-unicode-input-method { };

  header-file-mode = callPackage ./manual-packages/header-file-mode { };

  helm-words = callPackage ./manual-packages/helm-words { };

  idris2-mode = callPackage ./manual-packages/idris2-mode { };

  isearch-plus = callPackage ./manual-packages/isearch-plus { };

  isearch-prop = callPackage ./manual-packages/isearch-prop { };

  jam-mode = callPackage ./manual-packages/jam-mode { };

  ligo-mode = callPackage ./manual-packages/ligo-mode { };

  llvm-mode = callPackage ./manual-packages/llvm-mode { };

  lsp-bridge = callPackage ./manual-packages/lsp-bridge {
    inherit (pkgs) python3 git go gopls pyright;
  };

  matrix-client = callPackage ./manual-packages/matrix-client {
    _map = self.map;
  };

  ott-mode = callPackage ./manual-packages/ott-mode { };

  perl-completion = callPackage ./manual-packages/perl-completion { };

  pod-mode = callPackage ./manual-packages/pod-mode { };

  power-mode = callPackage ./manual-packages/power-mode { };

  prisma-mode = callPackage ./manual-packages/prisma-mode { };

  structured-haskell-mode = self.shm;

  sv-kalender = callPackage ./manual-packages/sv-kalender { };

  tree-sitter-langs = callPackage ./manual-packages/tree-sitter-langs { final = self; };

  tsc = callPackage ./manual-packages/tsc { };

  urweb-mode = callPackage ./manual-packages/urweb-mode { };

  voicemacs = callPackage ./manual-packages/voicemacs { };

  wat-mode = callPackage ./manual-packages/wat-mode { };

  yes-no = callPackage ./manual-packages/yes-no { };

  youtube-dl = callPackage ./manual-packages/youtube-dl { };

  # From old emacsPackages (pre emacsPackagesNg)
  cedille = callPackage ./manual-packages/cedille { inherit (pkgs) cedille; };
  color-theme-solarized = callPackage ./manual-packages/color-theme-solarized { };
  hsc3-mode = callPackage ./manual-packages/hsc3 { };
  prolog-mode = callPackage ./manual-packages/prolog { };
  rect-mark = callPackage ./manual-packages/rect-mark { };
  session-management-for-emacs = callPackage ./manual-packages/session-management-for-emacs { };
  sunrise-commander = callPackage ./manual-packages/sunrise-commander { };

  # camelCase aliases for some of the kebab-case expressions above
  colorThemeSolarized = self.color-theme-solarized;
  emacsSessionManagement = self.session-management-for-emacs;
  rectMark = self.rect-mark;
  sunriseCommander = self.sunrise-commander;
}
