{ lib, external, pkgs }: self: with self; with lib.licenses; {

  elisp-ffi = melpaBuild rec {
    pname = "elisp-ffi";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "skeeto";
      repo = "elisp-ffi";
      rev = "${version}";
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

  ghc-mod = melpaBuild rec {
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

  haskell-unicode-input-method = melpaBuild rec {
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

  rtags = melpaBuild rec {
    inherit (external.rtags) version src meta;

    pname = "rtags";

    dontConfigure = true;

    propagatedUserEnvPkgs = [ external.rtags ];
    recipe = pkgs.writeText "recipe" ''
      (rtags
       :repo "andersbakken/rtags" :fetcher github
       :files ("src/*.el"))
    '';
  };

  lib-requires =
    callPackage ./lib-requires { };

  org-mac-link =
    callPackage ./org-mac-link { };

  perl-completion =
    callPackage ./perl-completion { };

  railgun = callPackage ./railgun { };

  gn = callPackage ./gn { };

  structured-haskell-mode = self.shm;

  thingatpt-plus = callPackage ./thingatpt-plus { };

  tramp = callPackage ./tramp { };

  yaoddmuse = callPackage ./yaoddmuse { };

  zeitgeist = callPackage ./zeitgeist { };

}
