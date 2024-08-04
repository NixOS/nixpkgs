# builder for Emacs packages built for packages.el

{ lib, stdenv, emacs, texinfo, writeText }:

let
  handledArgs = [ "meta" ];
  genericBuild = import ./generic.nix { inherit lib stdenv emacs texinfo writeText; };

in

{ pname
, version
, src
, meta ? {}
, ...
}@args:

genericBuild ({

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

// removeAttrs args handledArgs)
