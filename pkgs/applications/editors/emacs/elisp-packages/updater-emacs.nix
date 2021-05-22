let
  pkgs = import ../../../../.. {};

  emacsEnv = pkgs.emacs.pkgs.withPackages (epkgs: let

    promise = epkgs.trivialBuild {
      pname = "promise";
      version = "1";
      src = pkgs.fetchFromGitHub {
        owner = "bendlas";
        repo = "emacs-promise";
        rev = "4da97087c5babbd8429b5ce62a8323b9b03c6022";
        sha256 = "0yin7kj69g4zxs30pvk47cnfygxlaw7jc7chr3b36lz51yqczjsy";
      };
    };

    semaphore = epkgs.trivialBuild {
      pname = "semaphore";
      version = "1";
      packageRequires = [ promise ];
      src = pkgs.fetchFromGitHub {
        owner = "webnf";
        repo = "semaphore.el";
        rev = "93802cb093073bc6a6ccd797328dafffcef248e0";
        sha256 = "09pfyp27m35sv340xarhld7xx2vv5fs5xj4418709iw6l6hpk853";
      };
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
