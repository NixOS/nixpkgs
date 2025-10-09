# trivial builder for Emacs packages

{ callPackage, lib, ... }@envargs:

lib.extendMkDerivation {
  constructDrv = callPackage ./generic.nix envargs;
  extendDrvArgs =
    finalAttrs:

    args:

    {
      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          # This is modified from stdenv buildPhase. foundMakefile is used in stdenv checkPhase.
          if [[ ! ( -z "''${makeFlags-}" && -z "''${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ) ]]; then
            foundMakefile=1
          fi

          emacs -l package -f package-initialize \
            --eval "(setq byte-compile-debug ${if finalAttrs.ignoreCompilationError then "nil" else "t"})" \
            --eval "(setq byte-compile-error-on-warn ${
              if finalAttrs.turnCompilationWarningToError then "t" else "nil"
            })" \
            -L . --batch -f batch-byte-compile *.el

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          LISPDIR=$out/share/emacs/site-lisp
          install -d $LISPDIR
          install *.el *.elc $LISPDIR

          runHook postInstall
        '';
    };

}
