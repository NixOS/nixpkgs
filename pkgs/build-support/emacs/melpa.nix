# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{ lib, stdenv, fetchurl, emacs, texinfo }:

with lib;

{ pname
, version

, files ? null
, fileSpecs ? [ "*.el" "*.el.in" "dir"
                "*.info" "*.texi" "*.texinfo"
                "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
              ]

, meta ? {}

, ...
}@args:

let

  packageBuild = fetchurl {
    url = https://raw.githubusercontent.com/milkypostman/melpa/12a862e5c5c62ce627dab83d7cf2cca6e8b56c47/package-build.el;
    sha256 = "1nviyyprypz7nmam9rwli4yv3kxh170glfbznryrp4czxkrjjdhk";
  };

  fname = "${pname}-${version}";

  targets = concatStringsSep " " (if files == null then fileSpecs else files);

  defaultMeta = {
    homepage = args.src.meta.homepage or "http://melpa.org/#/${pname}";
  };

in

import ./generic.nix { inherit lib stdenv emacs texinfo; } ({
  inherit packageBuild;

  buildPhase = ''
    runHook preBuild

    emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
      -f melpa2nix-build-package \
      ${pname} ${version} ${targets}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
      -f melpa2nix-install-package \
      ${fname}.* $out/share/emacs/site-lisp/elpa

    runHook postInstall
  '';

  meta = defaultMeta // meta;
}

// removeAttrs args [ "files" "fileSpecs"
                      "meta"
                    ])
