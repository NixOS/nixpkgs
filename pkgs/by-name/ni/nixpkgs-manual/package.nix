{
  lib,
  stdenvNoCC,
  callPackage,
  nixos-render-docs,
  documentation-highlighter,
  nixpkgs ? { },
}:

let
  optionsDoc = callPackage ./options-json.nix { };
  lib-docs = callPackage ./lib-function-docs.nix { inherit nixpkgs; };
  epub = callPackage ./epub.nix { };
  manpage-urls = callPackage ./manpage-urls.nix { };
in

stdenvNoCC.mkDerivation {
  name = "nixpkgs-manual";

  nativeBuildInputs = [ nixos-render-docs ];

  src = ../../../../doc/.;

  postPatch = ''
    ln -s ${optionsDoc.optionsJSON}/share/doc/nixos/options.json ./config-options.json
  '';

  buildPhase = ''
    cat ./functions/library.md.in ${lib-docs}/index.md > ./functions/library.md
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
      --revision ${lib.trivial.revisionWithDefault (nixpkgs.rev or "master")} \
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
    inherit optionsDoc lib-docs epub;
    tests = {
      inherit manpage-urls;
    };
  };
}
