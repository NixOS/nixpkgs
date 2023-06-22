{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  inherit (pkgs) lib;
  inherit (lib) hasPrefix removePrefix;

  doc-support = import ./doc-support { inherit pkgs nixpkgs; };

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

  src = ./.;

  postPatch = ''
    ln -s ${doc-support} ./doc-support/result
    ln -s ${optionsDoc.optionsJSON}/share/doc/nixos/options.json ./config-options.json
  '';

  buildPhase = ''
    cat \
      ./functions/library.md.in \
      ./doc-support/result/function-docs/index.md \
      > ./functions/library.md
    substitute ./manual.md.in ./manual.md \
      --replace '@MANUAL_VERSION@' '${pkgs.lib.version}'

    mkdir -p out/media

    mkdir -p out/highlightjs
    cp -t out/highlightjs \
      ${pkgs.documentation-highlighter}/highlight.pack.js \
      ${pkgs.documentation-highlighter}/LICENSE \
      ${pkgs.documentation-highlighter}/mono-blue.css \
      ${pkgs.documentation-highlighter}/loader.js

    cp -t out ./overrides.css ./style.css

    nixos-render-docs manual html \
      --manpage-urls ./manpage-urls.json \
      --revision ${pkgs.lib.trivial.revisionWithDefault (pkgs.rev or "master")} \
      --stylesheet style.css \
      --stylesheet overrides.css \
      --stylesheet highlightjs/mono-blue.css \
      --script ./highlightjs/highlight.pack.js \
      --script ./highlightjs/loader.js \
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
}
