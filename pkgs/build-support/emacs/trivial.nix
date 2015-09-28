# trivial builder for Emacs packages

{ lib, stdenv, texinfo, ... }@envargs:

with lib;

args:

import ./generic.nix envargs ({
  #preConfigure = ''
  #  export LISPDIR=$out/share/emacs/site-lisp
  #  export VERSION_SPECIFIC_LISPDIR=$out/share/emacs/site-lisp
  #'';

  buildPhase = ''
    eval "$preBuild"

    emacs -L . --batch -f batch-byte-compile *.el

    eval "$postBuild"
  '';

  installPhase = ''
    eval "$preInstall"

    LISPDIR=$out/share/emacs/site-lisp
    install -d $LISPDIR
    install *.el *.elc $LISPDIR

    eval "$postInstall"
  '';
}

// args)
