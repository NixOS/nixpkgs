{ lib, pkgs }:

self: with self; {

  elisp-ffi = callPackage ./elisp-ffi { };

  ghc-mod = callPackage ./elisp-ffi { };

  haskell-unicode-input-method = callPackage ./haskell-unicode-input-method { };

  matrix-client = callPackage ./matrix-client { _map = self.map; };

  prisma-mode = callPackage ./prisma-mode { };

  agda-input = callPackage ./agda-input { };

  agda2-mode = callPackage ./agda2-mode { };

  bqn-mode = callPackage ./bqn-mode { };

  cask = callPackage ./cask { };

  control-lock = callPackage ./control-lock { };

  ebuild-mode = callPackage ./ebuild-mode { };

  emacspeak = callPackage ./emacspeak { };

  ement = callPackage ./ement { };

  ess-R-object-popup = callPackage ./ess-R-object-popup { };

  evil-markdown = callPackage ./evil-markdown { };

  font-lock-plus = callPackage ./font-lock-plus { };

  git-undo = callPackage ./git-undo { };

  header-file-mode = callPackage ./header-file-mode { };

  helm-words = callPackage ./helm-words { };

  idris2-mode = callPackage ./idris2-mode { };

  isearch-plus = callPackage ./isearch-plus { };

  isearch-prop = callPackage ./isearch-prop { };

  jam-mode = callPackage ./jam-mode { };

  llvm-mode = callPackage ./llvm-mode { };

  nano-theme = callPackage ./nano-theme { };

  ott-mode = callPackage ./ott-mode { };

  perl-completion = callPackage ./perl-completion { };

  pod-mode = callPackage ./pod-mode { };

  power-mode = callPackage ./power-mode { };

  structured-haskell-mode = self.shm;

  sv-kalender = callPackage ./sv-kalender { };

  tree-sitter-langs = callPackage ./tree-sitter-langs { final = self; };

  tsc = callPackage ./tsc { };

  urweb-mode = callPackage ./urweb-mode { };

  voicemacs = callPackage ./voicemacs { };

  yes-no = callPackage ./yes-no { };

  youtube-dl = callPackage ./youtube-dl { };

  # From old emacsPackages (pre emacsPackagesNg)
  cedille = callPackage ./cedille { cedille = pkgs.cedille; };
  color-theme-solarized = callPackage ./color-theme-solarized { };
  session-management-for-emacs = callPackage ./session-management-for-emacs { };
  hsc3-mode = callPackage ./hsc3 { };
  prolog-mode = callPackage ./prolog { };
  rect-mark = callPackage ./rect-mark { };
  sunrise-commander = callPackage ./sunrise-commander { };

  # camelCase aliases for some of the kebab-case expressions above
  colorThemeSolarized = color-theme-solarized;
  emacsSessionManagement = session-management-for-emacs;
  rectMark = rect-mark;
  sunriseCommander = sunrise-commander;

}
