# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{ lib, stdenv, fetchFromGitHub, emacs, texinfo }:

with lib;

{ /*
    pname: Nix package name without special symbols and without version or
    "emacs-" prefix.
  */
  pname
  /*
    ename: Original Emacs package name, possibly containing special symbols.
  */
, ename ? null
, version
, recipe
, meta ? {}
, ...
}@args:

let

  defaultMeta = {
    homepage = args.src.meta.homepage or "http://melpa.org/#/${pname}";
  };

in

import ./generic.nix { inherit lib stdenv emacs texinfo; } ({

  ename =
    if isNull(ename)
    then pname
    else ename;

  melpa = fetchFromGitHub {
    owner = "melpa";
    repo = "melpa";
    rev = "7103313a7c31bb1ebb71419e365cd2e279ee4609";
    sha256 = "0m10f83ix0mzjk0vjd4kkb1m1p4b8ha0ll2yjsgk9bqjd7fwapqb";
  };

  elpa2nix = ./elpa2nix.el;
  melpa2nix = ./melpa2nix.el;

  preUnpack = ''
    mkdir -p "$NIX_BUILD_TOP/recipes"
    if [ -n "$recipe" ]; then
      cp "$recipe" "$NIX_BUILD_TOP/recipes/$ename"
    fi

    ln -s "$melpa/package-build" "$NIX_BUILD_TOP/package-build"

    mkdir -p "$NIX_BUILD_TOP/packages"
  '';

  postUnpack = ''
    mkdir -p "$NIX_BUILD_TOP/working"
    ln -s "$NIX_BUILD_TOP/$sourceRoot" "$NIX_BUILD_TOP/working/$ename"
  '';

  buildPhase =
    ''
      runHook preBuild

      cd "$NIX_BUILD_TOP"

      emacs --batch -Q \
          -L "$melpa/package-build" \
          -l "$melpa2nix" \
          -f melpa2nix-build-package \
          $ename $version

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    archive="$NIX_BUILD_TOP/packages/$ename-$version.el"
    if [ ! -f "$archive" ]; then
        archive="$NIX_BUILD_TOP/packages/$ename-$version.tar"
    fi

    emacs --batch -Q \
        -l "$elpa2nix" \
        -f elpa2nix-install-package \
        "$archive" "$out/share/emacs/site-lisp/elpa"

    runHook postInstall
  '';

  meta = defaultMeta // meta;
}

// removeAttrs args [ "meta" ])
