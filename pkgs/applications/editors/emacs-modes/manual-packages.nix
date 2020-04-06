{ lib, external, pkgs }: self: with self; with lib.licenses; {

  elisp-ffi = melpaBuild rec {
    pname = "elisp-ffi";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "skeeto";
      repo = "elisp-ffi";
      rev = version;
      sha256 = "0z2n3h5l5fj8wl8i1ilfzv11l3zba14sgph6gz7dx7q12cnp9j22";
    };
    buildInputs = [ external.libffi ];
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

  agda2-mode = with external; trivialBuild {
    pname = "agda-mode";
    version = Agda.version;

    phases = [ "buildPhase" "installPhase" ];

    # already byte-compiled by Agda builder
    buildPhase = ''
      agda=`${Agda}/bin/agda-mode locate`
      cp `dirname $agda`/*.el* .
    '';

    meta = {
      description = "Agda2-mode for Emacs extracted from Agda package";
      longDescription = ''
        Wrapper packages that liberates init.el from `agda-mode locate` magic.
        Simply add this to user profile or systemPackages and do `(require 'agda2)` in init.el.
      '';
      homepage = Agda.meta.homepage;
      license = Agda.meta.license;
    };
  };

  ess-R-object-popup =
    callPackage ./ess-R-object-popup { };

  filesets-plus = callPackage ./filesets-plus { };

  font-lock-plus = callPackage ./font-lock-plus { };

  ghc-mod = melpaBuild {
    pname = "ghc";
    version = external.ghc-mod.version;
    src = external.ghc-mod.src;
    packageRequires = [ haskell-mode ];
    propagatedUserEnvPkgs = [ external.ghc-mod ];
    recipe = pkgs.writeText "recipe" ''
      (ghc-mod :repo "DanielG/ghc-mod" :fetcher github :files ("elisp/*.el"))
    '';
    fileSpecs = [ "elisp/*.el" ];
    meta = {
      description = "An extension of haskell-mode that provides completion of symbols and documentation browsing";
      license = bsd3;
    };
  };

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

  hexrgb = callPackage ./hexrgb { };

  header2 = callPackage ./header2 { };

  helm-words = callPackage ./helm-words { };

  icicles = callPackage ./icicles { };

  lib-requires =
    callPackage ./lib-requires { };

  org-mac-link =
    callPackage ./org-mac-link { };

  perl-completion =
    callPackage ./perl-completion { };

  pod-mode = callPackage ./pod-mode { };

  railgun = callPackage ./railgun { };

  structured-haskell-mode = self.shm;

  sv-kalender = callPackage ./sv-kalender { };

  thingatpt-plus = callPackage ./thingatpt-plus { };

  tramp = callPackage ./tramp { };

  yaoddmuse = callPackage ./yaoddmuse { };

  zeitgeist = callPackage ./zeitgeist { };

  # From old emacsPackages (pre emacsPackagesNg)
  cedet = callPackage ./cedet { };
  cedille = callPackage ./cedille { cedille = pkgs.cedille; };
  colorThemeSolarized = callPackage ./color-theme-solarized { };
  emacsSessionManagement = callPackage ./session-management-for-emacs { };
  hsc3-mode = callPackage ./hsc3 { };
  hol_light_mode = callPackage ./hol_light { };
  ido-ubiquitous = callPackage ./ido-ubiquitous { };
  ocaml-mode = callPackage ./ocaml { };
  prolog-mode = callPackage ./prolog { };
  rectMark = callPackage ./rect-mark { };
  sunriseCommander = callPackage ./sunrise-commander { };

  # Legacy aliases, these try to mostly map to melpa stable because it's
  # closer to the old outdated package infra.
  #
  # Ideally this should be dropped some time during/after 20.03
  bbdb3 = self.melpaStablePackages.bbdb;
  ocamlMode = self.ocaml-mode;
  jade = self.jade-mode;
  # scalaMode2 = null;  # No clear mapping as of now
  flymakeCursor = self.melpaStablePackages.flymake-cursor;
  cryptol = self.melpaStablePackages.cryptol-mode;
  maudeMode = self.maude-mode;
  phpMode = self.melpaStablePackages.php-mode;
  idris = self.melpaStablePackages.idris-mode;
  rainbowDelimiters = self.melpaStablePackages.rainbow-delimiters;
  colorTheme = self.color-theme;
  sbtMode = self.melpaStablePackages.sbt-mode;
  markdownMode = self.melpaStablePackages.markdown-mode;
  scalaMode1 = self.melpaStablePackages.scala-mode;
  prologMode = self.prolog-mode;
  hsc3Mode = self.hsc3-mode;
  graphvizDot = self.melpaStablePackages.graphviz-dot-mode;
  proofgeneral_HEAD = self.proof-general;
  proofgeneral = self.melpaStablePackages.proof-general;
  haskellMode = self.melpaStablePackages.haskell-mode;
  writeGood = self.melpaStablePackages.writegood-mode;
  erlangMode = self.melpaStablePackages.erlang;
  d = self.melpaStablePackages.d-mode;
  autoComplete = self.melpaStablePackages.auto-complete;
  tuaregMode = self.melpaStablePackages.tuareg;
  structuredHaskellMode = self.melpaStablePackages.shm;
  xmlRpc = self.melpaStablePackages.xml-rpc;
  emacsw3m = self.w3m;
  loremIpsum = self.lorem-ipsum;
  js2 = self.melpaStablePackages.js2-mode;

}
