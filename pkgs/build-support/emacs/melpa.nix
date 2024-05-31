# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{ lib, stdenv, fetchFromGitHub, emacs, texinfo, writeText, gcc }:

let
  genericBuild = import ./generic.nix { inherit lib stdenv emacs texinfo writeText gcc; };

  packageBuild = stdenv.mkDerivation {
    name = "package-build";
    src = fetchFromGitHub {
      owner = "melpa";
      repo = "package-build";
      rev = "c48aa078c01b4f07b804270c4583a0a58ffea1c0";
      sha256 = "sha256-MzPj375upIiYXdQR+wWXv3A1zMqbSrZlH0taLuxx/1M=";
    };

    patches = [ ./package-build-dont-use-mtime.patch ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = "
      mkdir -p $out
      cp -r * $out
    ";
  };

in

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
  /*
    commit: Optional package history commit.
    Default: src.rev or "unknown"
    This will be written into the generated package but it is not needed during
    the build process.
  */
, commit ? (args.src.rev or "unknown")
, recipe
, meta ? {}
, ...
}@args:

genericBuild ({

  ename =
    if ename == null
    then pname
    else ename;

  elpa2nix = ./elpa2nix.el;
  melpa2nix = ./melpa2nix.el;

  inherit packageBuild commit;

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

  meta = {
    homepage = args.src.meta.homepage or "https://melpa.org/#/${pname}";
  } // meta;
}

// removeAttrs args [ "meta" ])
