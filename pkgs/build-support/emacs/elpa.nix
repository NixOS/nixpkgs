# builder for Emacs packages built for packages.el

{
  lib,
  stdenv,
  emacs,
  texinfo,
  writeText,
  gcc,
}:

let
  handledArgs = [
    "files"
    "fileSpecs"
    "meta"
  ];
  genericBuild = import ./generic.nix {
    inherit
      lib
      stdenv
      emacs
      texinfo
      writeText
      gcc
      ;
  };

in

{
  pname,
  version,
  src,
  meta ? { },
  ...
}@args:

genericBuild (
  {

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      emacs --batch -Q -l ${./elpa2nix.el} \
          -f elpa2nix-install-package \
          "$src" "$out/share/emacs/site-lisp/elpa"

      runHook postInstall
    '';

    meta = {
      homepage = args.src.meta.homepage or "https://elpa.gnu.org/packages/${pname}.html";
    } // meta;
  }

  // removeAttrs args handledArgs
)
