let
  pkgs = import ../../../../.. { };

  emacs2nix-source = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "emacs2nix";
    rev = "9458961fc433a6c4cd91e7763f0aa1ef15f7b4aa";
    hash = "sha256-NJVKrYSF/22hrUJNJ3/znbcfHi/FtTePQ8Xzfp2eKAk=";
    fetchSubmodules = true;
  };

  emacsEnv = pkgs.emacs.pkgs.withPackages (
    epkgs:
    let

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

    in
    [
      promise
      semaphore
    ]
  );

in
pkgs.mkShell {
  packages = [
    emacsEnv
    pkgs.bash
    pkgs.git
    pkgs.nix
    pkgs.nix-prefetch-git
    pkgs.nix-prefetch-hg
    pkgs.nixfmt
    pkgs.python
  ];

  shellHook = ''
    export EMACS2NIX=${emacs2nix-source}
    export PATH=$PATH:${emacs2nix-source}
  '';
}
