# builder for Emacs packages built for packages.el

{ lib, stdenv, emacs, texinfo, writeText, gcc }:

{ pname
, version
, src
, meta ? {}
, ...
}@args:

let

  defaultMeta = {
    homepage = args.src.meta.homepage or "https://elpa.gnu.org/packages/${pname}.html";
  };

in

import ./generic.nix { inherit lib stdenv emacs texinfo writeText gcc; } ({

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    emacs --batch -Q -l ${./elpa2nix.el} \
        -f elpa2nix-install-package \
        "$src" "$out/share/emacs/site-lisp/elpa"

    runHook postInstall
  '';

  meta = defaultMeta // meta;
}

// removeAttrs args [ "files" "fileSpecs"
                      "meta"
                    ])
