# builder for Emacs packages built for packages.el

{
  lib,
  stdenv,
  emacs,
  texinfo,
}:

let
  genericBuild = import ./generic.nix {
    inherit
      lib
      stdenv
      emacs
      texinfo
      ;
  };

in

lib.extendMkDerivation {
  constructDrv = genericBuild;
  extendDrvArgs =
    finalAttrs:

    {
      pname,
      dontUnpack ? true,
      meta ? { },
      ...
    }@args:

    {

      elpa2nix = args.elpa2nix or ./elpa2nix.el;

      inherit dontUnpack;

      installPhase =
        args.installPhase or ''
          runHook preInstall

          emacs --batch -Q -l "$elpa2nix" \
              -f elpa2nix-install-package \
              "$src" "$out/share/emacs/site-lisp/elpa" \
              ${if finalAttrs.turnCompilationWarningToError then "t" else "nil"} \
              ${if finalAttrs.ignoreCompilationError then "t" else "nil"}

          runHook postInstall
        '';

      meta = {
        homepage = args.src.meta.homepage or "https://elpa.gnu.org/packages/${pname}.html";
      }
      // meta;
    };

}
