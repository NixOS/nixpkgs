# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{ lib, stdenv, fetchFromGitHub, emacs, texinfo, writeText, gcc }:

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
    homepage = args.src.meta.homepage or "https://melpa.org/#/${pname}";
  };

in

import ./generic.nix { inherit lib stdenv emacs texinfo writeText gcc; } ({

  ename =
    if ename == null
    then pname
    else ename;

  packageBuild = stdenv.mkDerivation {
    name = "package-build";
    src = fetchFromGitHub {
      owner = "melpa";
      repo = "package-build";
      rev = "c3c535e93d9dc92acd21ebc4b15016b5c3b90e7d";
      sha256 = "17z0wbqdd6fspbj43yq8biff6wfggk74xgnaf1xx6ynsp1i74is5";
    };

    patches = [ ./package-build-dont-use-mtime.patch ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = "
      mkdir -p $out
      cp -r * $out
    ";
  };

  elpa2nix = ./elpa2nix.el;
  melpa2nix = ./melpa2nix.el;

  preUnpack = ''
    mkdir -p "$NIX_BUILD_TOP/recipes"
    if [ -n "$recipe" ]; then
      cp "$recipe" "$NIX_BUILD_TOP/recipes/$ename"
    fi

    ln -s "$packageBuild" "$NIX_BUILD_TOP/package-build"

    mkdir -p "$NIX_BUILD_TOP/packages"
  '';

  postUnpack = ''
    mkdir -p "$NIX_BUILD_TOP/working"
    ln -s "$NIX_BUILD_TOP/$sourceRoot" "$NIX_BUILD_TOP/working/$ename"
  '';

  buildPhase = ''
    runHook preBuild

    cd "$NIX_BUILD_TOP"

    emacs --batch -Q \
        -L "$NIX_BUILD_TOP/package-build" \
        -l "$melpa2nix" \
        -f melpa2nix-build-package \
        $ename $version $commit

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
