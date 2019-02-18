{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  lib = pkgs.lib;
  locationsXml = import ./lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./lib-function-docs.nix { inherit locationsXml pkgs; };
in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";

  buildInputs = with pkgs; [ pandoc libxml2 libxslt zip jing  xmlformat ];

  src = ./.;

  # Hacking on these variables? Make sure to close and open
  # nix-shell between each test, maybe even:
  # $ nix-shell --run "make clean all"
  # otherwise they won't reapply :)
  HIGHLIGHTJS = pkgs.documentation-highlighter;
  XSL = "${pkgs.docbook_xsl_ns}/xml/xsl";
  RNG = "${pkgs.docbook5}/xml/rng/docbook/docbook.rng";
  XMLFORMAT_CONFIG = ../nixos/doc/xmlformat.conf;
  xsltFlags = lib.concatStringsSep " " [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--stringparam html.stylesheet 'style.css overrides.css highlightjs/mono-blue.css'"
    "--stringparam html.script './highlightjs/highlight.pack.js ./highlightjs/loader.js'"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .svg"
  ];

  postPatch = ''
    rm -rf ./functions/library/locations.xml
    ln -s ${locationsXml} ./functions/library/locations.xml
    ln -s ${functionDocs} ./functions/library/generated
    echo ${lib.version} > .version
  '';

  installPhase = ''
    dest="$out/share/doc/nixpkgs"
    mkdir -p "$(dirname "$dest")"
    mv out/html "$dest"
    mv "$dest/index.html" "$dest/manual.html"

    mv out/epub/manual.epub "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest manual.html" >> $out/nix-support/hydra-build-products
    echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products
  '';
}
