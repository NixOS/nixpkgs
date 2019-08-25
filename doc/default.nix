{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  lib = pkgs.lib;
  doc-support = import ./doc-support { inherit pkgs nixpkgs; };
in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";

  buildInputs = with pkgs; [ pandoc libxml2 libxslt zip jing xmlformat
    docbook-index ];

  src = ./.;

  postPatch = ''
    # Ensures we don't have the developer's files in the input.
    rm -rf ./out
    rm -f ./doc-support/result
    ln -s ${doc-support} ./doc-support/result
  '';

  installPhase = ''
    dest="$out/share/doc/nixpkgs"
    mkdir -p "$(dirname "$dest")"
    mv out/html "$dest"
    mv out/epub/manual.epub "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest index.html" >> $out/nix-support/hydra-build-products
    echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products
  '';
}
