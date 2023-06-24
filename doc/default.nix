{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let
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

  preBuild = ''
    make -j$NIX_BUILD_CORES render-md
  '';

  installPhase = ''
    dest="$out/share/doc/nixpkgs"
    mkdir -p "$(dirname "$dest")"
    mv out/html "$dest"
    mv "$dest/index.html" "$dest/manual.html"

    cp ${epub} "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest manual.html" >> $out/nix-support/hydra-build-products
    echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products
  '';

  # Environment variables
  PANDOC_LUA_FILTERS_DIR = "${pkgs.pandoc-lua-filters}/share/pandoc/filters";
  PANDOC_LINK_MANPAGES_FILTER = import build-aux/pandoc-filters/link-manpages.nix { inherit pkgs; };
}
