{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  inherit (pkgs) lib callPackage;
  fs = lib.fileset;

  common = import ./common.nix;

  lib-docs = callPackage ./doc-support/lib-function-docs.nix {
    inherit nixpkgs;
  };

  epub = callPackage ./doc-support/epub.nix { };

  # NB: This file describes the Nixpkgs manual, which happens to use module docs infra originally developed for NixOS.
  optionsDoc = callPackage ./doc-support/options-doc.nix { };

in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";

  nativeBuildInputs = with pkgs; [
    nixos-render-docs
  ];

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      (fs.fileFilter (file:
        file.hasExt "md"
        || file.hasExt "md.in"
      ) ./.)
      ./style.css
      ./anchor-use.js
      ./anchor.min.js
      ./manpage-urls.json
    ];
  };

  postPatch = ''
    ln -s ${optionsDoc.optionsJSON}/share/doc/nixos/options.json ./config-options.json
  '';

  pythonInterpreterTable = pkgs.callPackage ./doc-support/python-interpreter-table.nix {};

  passAsFile = [ "pythonInterpreterTable" ];

  buildPhase = ''
    substituteInPlace ./languages-frameworks/python.section.md --subst-var-by python-interpreter-table "$(<"$pythonInterpreterTablePath")"

    cat \
      ./functions/library.md.in \
      ${lib-docs}/index.md \
      > ./functions/library.md
    substitute ./manual.md.in ./manual.md \
      --replace-fail '@MANUAL_VERSION@' '${pkgs.lib.version}'

    mkdir -p out/media

    mkdir -p out/highlightjs
    cp -t out/highlightjs \
      ${pkgs.documentation-highlighter}/highlight.pack.js \
      ${pkgs.documentation-highlighter}/LICENSE \
      ${pkgs.documentation-highlighter}/mono-blue.css \
      ${pkgs.documentation-highlighter}/loader.js

    cp -t out ./style.css ./anchor.min.js ./anchor-use.js

    nixos-render-docs manual html \
      --manpage-urls ./manpage-urls.json \
      --revision ${pkgs.lib.trivial.revisionWithDefault (pkgs.rev or "master")} \
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
    dest="$out/${common.outputPath}"
    mkdir -p "$(dirname "$dest")"
    mv out "$dest"
    mv "$dest/index.html" "$dest/${common.indexPath}"

    cp ${epub} "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest ${common.indexPath}" >> $out/nix-support/hydra-build-products
    echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products
  '';

  passthru.tests.manpage-urls = with pkgs; testers.invalidateFetcherByDrvHash
    ({ name ? "manual_check-manpage-urls"
     , script
     , urlsFile
     }: runCommand name {
      nativeBuildInputs = [
        cacert
        (python3.withPackages (p: with p; [
          aiohttp
          rich
          structlog
        ]))
      ];
      outputHash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";  # Empty output
    } ''
      python3 ${script} ${urlsFile}
      touch $out
    '') {
      script = ./tests/manpage-urls.py;
      urlsFile = ./manpage-urls.json;
    };
}
