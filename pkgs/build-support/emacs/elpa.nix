# builder for Emacs packages built for packages.el

{ lib, stdenv, fetchurl, emacs, texinfo }:

with lib;

{ pname
, version
, src
, ...
}@args:

import ./generic.nix { inherit lib stdenv emacs texinfo; } ({

  phases = "installPhase fixupPhase distPhase";

  installPhase = ''
    runHook preInstall

    emacs --batch -Q -l ${./elpa2nix.el} \
        -f elpa2nix-install-package \
        "${src}" "$out/share/emacs/site-lisp/elpa"

    runHook postInstall
  '';
}

// removeAttrs args [ "files" "fileSpecs"
                      "meta"
                    ])
