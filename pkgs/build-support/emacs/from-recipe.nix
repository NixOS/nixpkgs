# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{ lib, stdenv, fetchFromGitHub, emacs, texinfo, packageBuild }:

with lib;

{ pname
, version
, recipe
, meta ? {}
, ...
}@args:

let

  defaultMeta = {
    homepage = "http://melpa.org/#/${pname}";
  };

  fname = "${pname}-${version}";

in

import ./generic.nix { inherit lib stdenv emacs texinfo; } ({
  buildPhase = ''
    runHook preBuild

    emacs --batch -Q -l "${packageBuild}" -l "${./melpa2nix.el}" \
      -f melpa2nix-build-package-from-recipe "${recipe}" "${pname}" "${version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    emacs --batch -Q -l "${packageBuild}" -l "${./melpa2nix.el}" \
      -f melpa2nix-install-package \
      "${fname}".* "$out/share/emacs/site-lisp/elpa"

    runHook postInstall
  '';

  meta = defaultMeta // meta;
}

// removeAttrs args [ "meta" ])
