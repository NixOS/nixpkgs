{ lib, pkgs }: self: with self; with lib.licenses; {

  elisp-ffi = melpaBuild rec {
    pname = "elisp-ffi";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "skeeto";
      repo = "elisp-ffi";
      rev = version;
      sha256 = "0z2n3h5l5fj8wl8i1ilfzv11l3zba14sgph6gz7dx7q12cnp9j22";
    };

    buildInputs = [ pkgs.libffi ];

    preBuild = "make";

    recipe = pkgs.writeText "recipe" ''
      (elisp-ffi
      :repo "skeeto/elisp-ffi"
      :fetcher github
      :files ("ffi-glue" "ffi.el"))
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

    phases = [ "buildPhase" "installPhase" ];

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

  haskell-unicode-input-method = melpaBuild {
    pname = "emacs-haskell-unicode-input-method";
    version = "20110905.2307";

    src = pkgs.fetchFromGitHub {
      owner = "roelvandijk";
      repo = "emacs-haskell-unicode-input-method";
      rev = "d8d168148c187ed19350bb7a1a190217c2915a63";
      sha256 = "09b7bg2s9aa4s8f2kdqs4xps3jxkq5wsvbi87ih8b6id38blhf78";
    };

    recipe = pkgs.writeText "recipe" ''
      (emacs-haskell-unicode-input-method
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

  matrix-client = melpaBuild {
    pname = "matrix-client";
    version = "0.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "alphapapa";
      repo = "matrix-client.el";
      rev = "d2ac55293c96d4c95971ed8e2a3f6f354565c5ed";
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

  # Legacy aliases, these try to mostly map to melpa stable because it's
  # closer to the old outdated package infra.
  #
  # Ideally this should be dropped some time during/after 20.03

  autoComplete = self.melpaStablePackages.auto-complete;
  bbdb3 = self.melpaStablePackages.bbdb;
  colorTheme = self.color-theme;
  cryptol = self.melpaStablePackages.cryptol-mode;
  d = self.melpaStablePackages.d-mode;
  emacsw3m = self.w3m;
  erlangMode = self.melpaStablePackages.erlang;
  flymakeCursor = self.melpaStablePackages.flymake-cursor;
  graphvizDot = self.melpaStablePackages.graphviz-dot-mode;
  haskellMode = self.melpaStablePackages.haskell-mode;
  hsc3Mode = self.hsc3-mode;
  idris = self.melpaStablePackages.idris-mode;
  jade = self.jade-mode;
  js2 = self.melpaStablePackages.js2-mode;
  loremIpsum = self.lorem-ipsum;
  markdownMode = self.melpaStablePackages.markdown-mode;
  maudeMode = self.maude-mode;
  phpMode = self.melpaStablePackages.php-mode;
  prologMode = self.prolog-mode;
  proofgeneral = self.melpaStablePackages.proof-general;
  proofgeneral_HEAD = self.proof-general;
  rainbowDelimiters = self.melpaStablePackages.rainbow-delimiters;
  sbtMode = self.melpaStablePackages.sbt-mode;
  scalaMode1 = self.melpaStablePackages.scala-mode;
  # scalaMode2 = null;  # No clear mapping as of now
  structuredHaskellMode = self.melpaStablePackages.shm;
  tuaregMode = self.melpaStablePackages.tuareg;
  writeGood = self.melpaStablePackages.writegood-mode;
  xmlRpc = self.melpaStablePackages.xml-rpc;
}
