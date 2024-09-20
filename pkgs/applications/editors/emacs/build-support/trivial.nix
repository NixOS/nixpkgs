# trivial builder for Emacs packages

{ callPackage, lib, ... }@envargs:

let
  libBuildHelper = import ./lib-build-helper.nix;
in

libBuildHelper.extendMkDerivation' (callPackage ./generic.nix envargs) (finalAttrs:

args:

{
  buildPhase = args.buildPhase or ''
    runHook preBuild

    # This is modified from stdenv buildPhase. foundMakefile is used in stdenv checkPhase.
    if [[ ! ( -z "''${makeFlags-}" && -z "''${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ) ]]; then
      foundMakefile=1
    fi

    emacs -L . --batch -f batch-byte-compile *.el

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    LISPDIR=$out/share/emacs/site-lisp
    install -d $LISPDIR
    install *.el *.elc $LISPDIR

    runHook postInstall
  '';
}

)
