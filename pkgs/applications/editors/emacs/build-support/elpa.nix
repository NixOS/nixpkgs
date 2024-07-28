# builder for Emacs packages built for packages.el

{ lib, stdenv, emacs, texinfo, writeText }:

let
  genericBuild = import ./generic.nix { inherit lib stdenv emacs texinfo writeText; };
  libBuildHelper = import ./lib-build-helper.nix { inherit lib; };

in

libBuildHelper.extendMkDerivation { } genericBuild (finalAttrs:

{ pname
, version
, src
, dontUnpack ? true
, meta ? {}
, ...
}@args:

{

  inherit dontUnpack;

  installPhase = args.installPhase or ''
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

)
