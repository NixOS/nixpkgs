{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  inherit (pkgs) lib;
  inherit (lib) hasPrefix removePrefix;
  fs = lib.fileset;

  common = import ./common.nix;

  lib-docs = import ./doc-support/lib-function-docs.nix {
    inherit pkgs nixpkgs;
    libsets = [
      { name = "asserts"; description = "assertion functions"; }
      { name = "attrsets"; description = "attribute set functions"; }
      { name = "strings"; description = "string manipulation functions"; }
      { name = "versions"; description = "version string functions"; }
      { name = "trivial"; description = "miscellaneous functions"; }
      { name = "fixedPoints"; baseName = "fixed-points"; description = "explicit recursion functions"; }
      { name = "lists"; description = "list manipulation functions"; }
      { name = "debug"; description = "debugging functions"; }
      { name = "options"; description = "NixOS / nixpkgs option handling"; }
      { name = "path"; description = "path functions"; }
      { name = "filesystem"; description = "filesystem functions"; }
      { name = "fileset"; description = "file set functions"; }
      { name = "sources"; description = "source filtering functions"; }
      { name = "cli"; description = "command-line serialization functions"; }
      { name = "gvariant"; description = "GVariant formatted string serialization functions"; }
      { name = "customisation"; description = "Functions to customise (derivation-related) functions, derivatons, or attribute sets"; }
      { name = "meta"; description = "functions for derivation metadata"; }
      { name = "derivations"; description = "miscellaneous derivation-specific functions"; }
    ];
  };

  epub = pkgs.runCommand "manual.epub" {
    nativeBuildInputs = with pkgs; [ libxslt zip ];

    epub = ''
      <book xmlns="http://docbook.org/ns/docbook"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            version="5.0"
            xml:id="nixpkgs-manual">
        <info>
          <title>Nixpkgs Manual</title>
          <subtitle>Version ${pkgs.lib.version}</subtitle>
        </info>
        <chapter>
          <title>Temporarily unavailable</title>
          <para>
            The Nixpkgs manual is currently not available in EPUB format,
            please use the <link xlink:href="https://nixos.org/nixpkgs/manual">HTML manual</link>
            instead.
          </para>
          <para>
            If you've used the EPUB manual in the past and it has been useful to you, please
            <link xlink:href="https://github.com/NixOS/nixpkgs/issues/237234">let us know</link>.
          </para>
        </chapter>
      </book>
    '';

    passAsFile = [ "epub" ];
  } ''
    mkdir scratch
    xsltproc \
      --param chapter.autolabel 0 \
      --nonet \
      --output scratch/ \
      ${pkgs.docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl \
      $epubPath

    echo "application/epub+zip" > mimetype
    zip -0Xq "$out" mimetype
    cd scratch && zip -Xr9D "$out" *
  '';

  # NB: This file describes the Nixpkgs manual, which happens to use module
  #     docs infra originally developed for NixOS.
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (pkgs.lib.evalModules {
      modules = [ ../pkgs/top-level/config.nix ];
      class = "nixpkgsConfig";
    }) options;
    documentType = "none";
    transformOptions = opt:
      opt // {
        declarations =
          map
            (decl:
              if hasPrefix (toString ../..) (toString decl)
              then
                let subpath = removePrefix "/" (removePrefix (toString ../.) (toString decl));
                in { url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}"; name = subpath; }
              else decl)
            opt.declarations;
        };
  };
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
