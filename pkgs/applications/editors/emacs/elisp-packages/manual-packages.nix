{ lib, pkgs }: self: with self; with lib.licenses; {

  elisp-ffi = let
    rev = "da37c516a0e59bdce63fb2dc006a231dee62a1d9";
  in melpaBuild {
    pname = "elisp-ffi";
    version = "20170518.0";

    commit = rev;

    src = pkgs.fetchFromGitHub {
      owner = "skeeto";
      repo = "elisp-ffi";
      inherit rev;
      sha256 = "sha256-StOezQEnNTjRmjY02ub5FRh59aL6gWfw+qgboz0wF94=";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];

    buildInputs = [ pkgs.libffi ];

    preBuild = ''
      mv ffi.el elisp-ffi.el
      make
    '';

    recipe = pkgs.writeText "recipe" ''
      (elisp-ffi
      :repo "skeeto/elisp-ffi"
      :fetcher github)
    '';

    meta = {
      description = "Emacs Lisp Foreign Function Interface";
      longDescription = ''
        This library provides an FFI for Emacs Lisp so that Emacs
        programs can invoke functions in native libraries. It works by
        driving a subprocess to do the heavy lifting, passing result
        values on to Emacs.
      '';
      license = publicDomain;
    };
  };

  ghc-mod = melpaBuild {
    pname = "ghc";
    version = pkgs.haskellPackages.ghc-mod.version;

    src = pkgs.haskellPackages.ghc-mod.src;

    packageRequires = [ haskell-mode ];

    propagatedUserEnvPkgs = [ pkgs.haskellPackages.ghc-mod ];

    recipe = pkgs.writeText "recipe" ''
      (ghc-mod :repo "DanielG/ghc-mod" :fetcher github :files ("elisp/*.el"))
    '';

    fileSpecs = [ "elisp/*.el" ];

    meta = {
      description = "An extension of haskell-mode that provides completion of symbols and documentation browsing";
      license = bsd3;
    };
  };

  haskell-unicode-input-method = let
    rev = "d8d168148c187ed19350bb7a1a190217c2915a63";
  in melpaBuild {
    pname = "haskell-unicode-input-method";
    version = "20110905.2307";

    commit = rev;

    src = pkgs.fetchFromGitHub {
      owner = "roelvandijk";
      repo = "emacs-haskell-unicode-input-method";
      inherit rev;
      sha256 = "09b7bg2s9aa4s8f2kdqs4xps3jxkq5wsvbi87ih8b6id38blhf78";
    };

    recipe = pkgs.writeText "recipe" ''
      (haskell-unicode-input-method
       :repo "roelvandijk/emacs-haskell-unicode-input-method"
       :fetcher github)
    '';

    packageRequires = [];

    meta = {
      homepage = "https://melpa.org/#haskell-unicode-input-method/";
      license = lib.licenses.free;
    };
  };

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
      license = gpl3Plus;
    };

  };

  agda2-mode = callPackage ./agda2-mode { };

  agda-input = callPackage ./agda-input{ };

  bqn-mode = callPackage ./bqn-mode { };

  llvm-mode = callPackage ./llvm-mode { };

  ott-mode = callPackage ./ott-mode { };

  urweb-mode = callPackage ./urweb-mode { };

  # Packages made the classical callPackage way

  apheleia = callPackage ./apheleia { };

  ebuild-mode = callPackage ./ebuild-mode { };

  evil-markdown = callPackage ./evil-markdown { };

  emacspeak = callPackage ./emacspeak { };

  ement = callPackage ./ement { };

  ess-R-object-popup = callPackage ./ess-R-object-popup { };

  font-lock-plus = callPackage ./font-lock-plus { };

  git-undo = callPackage ./git-undo { };

  header-file-mode = callPackage ./header-file-mode { };

  helm-words = callPackage ./helm-words { };

  isearch-plus = callPackage ./isearch-plus { };

  isearch-prop = callPackage ./isearch-prop { };

  jam-mode = callPackage ./jam-mode { };

  nano-theme = callPackage ./nano-theme { };

  perl-completion = callPackage ./perl-completion { };

  control-lock = callPackage ./control-lock { };

  pod-mode = callPackage ./pod-mode { };

  power-mode = callPackage ./power-mode { };

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
      license = gpl2Only;
    };
  };

  structured-haskell-mode = self.shm;

  sv-kalender = callPackage ./sv-kalender { };

  tree-sitter-langs = callPackage ./tree-sitter-langs { final = self; };
  tsc = callPackage ./tsc { };

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
