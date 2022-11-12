{ lib, pkgs }:

self: with self; {

  elisp-ffi = callPackage ./elisp-ffi { };

  ghc-mod = callPackage ./elisp-ffi { };

  haskell-unicode-input-method = callPackage ./haskell-unicode-input-method { };

  matrix-client = let
    rev = "d2ac55293c96d4c95971ed8e2a3f6f354565c5ed";
  in melpaBuild
  {
    pname = "matrix-client";
    version = "0.3.0";

    commit = rev;

    src = pkgs.fetchFromGitHub {
      owner = "alphapapa";
      repo = "matrix-client.el";
      inherit rev;
      sha256 = "1scfv1502yg7x4bsl253cpr6plml1j4d437vci2ggs764sh3rcqq";
    };

    patches = [
      # Fix: avatar loading when imagemagick support is not available
      (pkgs.fetchpatch {
        url = "https://github.com/alphapapa/matrix-client.el/commit/5f49e615c7cf2872f48882d3ee5c4a2bff117d07.patch";
        sha256 = "07bvid7s1nv1377p5n61q46yww3m1w6bw4vnd4iyayw3fby1lxbm";
      })
    ];

    packageRequires = [
      anaphora
      cl-lib
      self.map
      dash-functional
      esxml
      f
      ov
      tracking
      rainbow-identifiers
      dash
      s
      request
      frame-purpose
      a
      ht
    ];

    recipe = pkgs.writeText "recipe" ''
      (matrix-client
      :repo "alphapapa/matrix-client.el"
      :fetcher github)
    '';

    meta = {
      description = "A chat client and API wrapper for Matrix.org";
      license = lib.licenses.gpl3Plus;
    };

  };

  prisma-mode = let
    rev = "5283ca7403bcb21ca0cac8ecb063600752dfd9d4";
  in melpaBuild {
    pname = "prisma-mode";
    version = "20211207.0";

    commit = rev;

    packageRequires = [ js2-mode ];

    src = pkgs.fetchFromGitHub {
      owner = "pimeys";
      repo = "emacs-prisma-mode";
      inherit rev;
      sha256 = "sha256-DJJfjbu27Gi7Nzsa1cdi8nIQowKH8ZxgQBwfXLB0Q/I=";
    };

    recipe = pkgs.writeText "recipe" ''
      (prisma-mode
      :repo "pimeys/emacs-prisma-mode"
      :fetcher github)
    '';

    meta = {
      description = "Major mode for Prisma Schema Language";
      license = lib.licenses.gpl2Only;
    };
  };

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
