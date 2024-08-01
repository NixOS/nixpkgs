# This file describes the Nixpkgs manual, which happens to use module docs infra originally
# developed for NixOS. To build this derivation, run `nix-build -A nixpkgs-manual`.
#
{
  lib,
  stdenvNoCC,
  callPackage,
  documentation-highlighter,
  nixos-render-docs,
  nixpkgs ? { },
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    inherit (finalAttrs.finalPackage.optionsDoc) optionsJSON;
    inherit (finalAttrs.finalPackage) epub lib-docs pythonInterpreterTable;
  in
  {
    name = "nixpkgs-manual";

    nativeBuildInputs = [ nixos-render-docs ];

    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.unions [
        (lib.fileset.fileFilter (file: file.hasExt "md" || file.hasExt "md.in") ../.)
        ../style.css
        ../anchor-use.js
        ../anchor.min.js
        ../manpage-urls.json
      ];
    };

    postPatch = ''
      ln -s ${optionsJSON}/share/doc/nixos/options.json ./config-options.json
    '';

    buildPhase = ''
      substituteInPlace ./languages-frameworks/python.section.md \
        --subst-var-by python-interpreter-table "$(<"${pythonInterpreterTable}")"

      cat \
        ./functions/library.md.in \
        ${lib-docs}/index.md \
        > ./functions/library.md
      substitute ./manual.md.in ./manual.md \
        --replace-fail '@MANUAL_VERSION@' '${lib.version}'

      mkdir -p out/media

      mkdir -p out/highlightjs
      cp -t out/highlightjs \
        ${documentation-highlighter}/highlight.pack.js \
        ${documentation-highlighter}/LICENSE \
        ${documentation-highlighter}/mono-blue.css \
        ${documentation-highlighter}/loader.js

      cp -t out ./style.css ./anchor.min.js ./anchor-use.js

      nixos-render-docs manual html \
        --manpage-urls ./manpage-urls.json \
        --revision ${nixpkgs.rev or "master"} \
        --stylesheet style.css \
        --stylesheet highlightjs/mono-blue.css \
        --script ./highlightjs/highlight.pack.js \
        --script ./highlightjs/loader.js \
        --script ./anchor.min.js \
        --script ./anchor-use.js \
        --toc-depth 1 \
        --section-toc-depth 1 \
        manual.md \
        out/index.html
    '';

    installPhase = ''
      dest="$out/share/doc/nixpkgs"
      mkdir -p "$(dirname "$dest")"
      mv out "$dest"
      mv "$dest/index.html" "$dest/manual.html"

      cp ${epub} "$dest/nixpkgs-manual.epub"

      mkdir -p $out/nix-support/
      echo "doc manual $dest manual.html" >> $out/nix-support/hydra-build-products
      echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products
    '';

    passthru = {
      lib-docs = callPackage ./lib-function-docs.nix { inherit nixpkgs; };

      epub = callPackage ./epub.nix { };

      optionsDoc = callPackage ./options-doc.nix { };

      pythonInterpreterTable = callPackage ./python-interpreter-table.nix { };

      shell = callPackage ../../pkgs/tools/nix/web-devmode.nix {
        buildArgs = "./.";
        open = "/share/doc/nixpkgs/manual.html";
      };

      tests.manpage-urls = callPackage ../tests/manpage-urls.nix { };
    };
  }
)
