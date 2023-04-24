{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
  doc-support = import ./doc-support { inherit pkgs nixpkgs; };
in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";

  nativeBuildInputs = with pkgs; [
    pandoc
    graphviz
    libxml2
    libxslt
    zip
    jing
    xmlformat
  ];

  src = pkgs.nix-gitignore.gitignoreSource [] ./.;

  postPatch = ''
    ln -s ${doc-support} ./doc-support/result
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

  # Environment variables
  PANDOC_LUA_FILTERS_DIR = "${pkgs.pandoc-lua-filters}/share/pandoc/filters";
  PANDOC_LINK_MANPAGES_FILTER = import build-aux/pandoc-filters/link-manpages.nix { inherit pkgs; };
}
