let
  pkgs = import ../../../../.. {};

  emacsEnv = pkgs.emacs.pkgs.withPackages (epkgs: let

    promise = epkgs.melpaBuild {
      pname = "promise";
      version = "0-unstable-2019-06-07";

      src = pkgs.fetchFromGitHub {
        owner = "bendlas";
        repo = "emacs-promise";
        rev = "4da97087c5babbd8429b5ce62a8323b9b03c6022";
        hash = "sha256-XsvPsA/lUzPWyJAdJg9XtD/vLDtk7guG7p+8ZOQ8Nno=";
      };

      packageRequires = [ epkgs.async ];
    };

    semaphore = epkgs.melpaBuild {
      pname = "semaphore";
      version = "0-unstable-2019-06-07";

      src = pkgs.fetchFromGitHub {
        owner = "webnf";
        repo = "semaphore.el";
        rev = "93802cb093073bc6a6ccd797328dafffcef248e0";
        hash = "sha256-o6B5oaGGxwQOCoTIXrQre4veT6Mwqw7I2LqMesT17iY=";
      };

      packageRequires = [ promise ];
    };

  in [ promise semaphore ]);

in pkgs.mkShell {
  packages = [
    pkgs.git
    pkgs.nix
    pkgs.bash
    pkgs.nix-prefetch-git
    pkgs.nix-prefetch-hg
    emacsEnv
  ];
}
