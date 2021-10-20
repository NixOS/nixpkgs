# trivial builder for Emacs packages

{ callPackage, lib, ... }@envargs:

with lib;

args:

callPackage ./generic.nix envargs ({
  buildPhase = ''
    runHook preBuild

    emacs -L . --batch -f batch-byte-compile *.el

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    LISPDIR=$out/share/emacs/site-lisp
    install -d $LISPDIR
    install *.el *.elc $LISPDIR

    runHook postInstall
  '';
}

// args)
