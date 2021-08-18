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

  agda2-mode = trivialBuild {
    pname = "agda-mode";
    version = pkgs.haskellPackages.Agda.version;

    dontUnpack = true;

    # already byte-compiled by Agda builder
    buildPhase = ''
      agda=`${pkgs.haskellPackages.Agda}/bin/agda-mode locate`
      cp `dirname $agda`/*.el* .
    '';

    meta = {
      description = "Agda2-mode for Emacs extracted from Agda package";
      longDescription = ''
        Wrapper packages that liberates init.el from `agda-mode locate` magic.
        Simply add this to user profile or systemPackages and do `(require 'agda2)` in init.el.
      '';
      homepage = pkgs.haskellPackages.Agda.meta.homepage;
      license = pkgs.haskellPackages.Agda.meta.license;
    };
  };

  agda-input = self.trivialBuild {
    pname = "agda-input";

    inherit (pkgs.haskellPackages.Agda) src version;

    postUnpack = "mv $sourceRoot/src/data/emacs-mode/agda-input.el $sourceRoot";

    meta = {
      description = "Standalone package providing the agda-input method without building Agda.";
      inherit (pkgs.haskellPackages.Agda.meta) homepage license;
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

  git-undo = callPackage ./git-undo { };

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

  llvm-mode = trivialBuild {
    pname = "llvm-mode";
    inherit (pkgs.llvmPackages.llvm) src version;

    dontConfigure = true;
    buildPhase = ''
      cp utils/emacs/*.el .
    '';

    meta = {
      inherit (pkgs.llvmPackages.llvm.meta) homepage license;
      description = "Major mode for the LLVM assembler language.";
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

  ott-mode = self.trivialBuild {
    pname = "ott-mod";

    inherit (pkgs.ott) src version;

    postUnpack = "mv $sourceRoot/emacs/ott-mode.el $sourceRoot";

    meta = {
      description = "Standalone package providing ott-mode without building ott and with compiled bytecode.";
      inherit (pkgs.haskellPackages.Agda.meta) homepage license;
    };
  };

  # Packages made the classical callPackage way

  ebuild-mode = callPackage ./ebuild-mode { };

  emacspeak = callPackage ./emacspeak { };

  ess-R-object-popup = callPackage ./ess-R-object-popup { };

  font-lock-plus = callPackage ./font-lock-plus { };

  helm-words = callPackage ./helm-words { };

  jam-mode = callPackage ./jam-mode { };

  nano-theme = callPackage ./nano-theme { };

  org-mac-link = callPackage ./org-mac-link { };

  perl-completion = callPackage ./perl-completion { };

  pod-mode = callPackage ./pod-mode { };

  power-mode = callPackage ./power-mode { };

  railgun = callPackage ./railgun { };

  structured-haskell-mode = self.shm;

  sv-kalender = callPackage ./sv-kalender { };

  tramp = callPackage ./tramp { };

  youtube-dl = callPackage ./youtube-dl { };

  zeitgeist = callPackage ./zeitgeist { };

  # From old emacsPackages (pre emacsPackagesNg)
  cedet = callPackage ./cedet { };
  cedille = callPackage ./cedille { cedille = pkgs.cedille; };
  color-theme-solarized = callPackage ./color-theme-solarized { };
  session-management-for-emacs = callPackage ./session-management-for-emacs { };
  hsc3-mode = callPackage ./hsc3 { };
  ido-ubiquitous = callPackage ./ido-ubiquitous { };
  prolog-mode = callPackage ./prolog { };
  rect-mark = callPackage ./rect-mark { };
  sunrise-commander = callPackage ./sunrise-commander { };

  # camelCase aliases for some of the kebab-case expressions above
  colorThemeSolarized = color-theme-solarized;
  emacsSessionManagement = session-management-for-emacs;
  rectMark = rect-mark;
  sunriseCommander = sunrise-commander;

}
