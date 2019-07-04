{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  locationsXml = import ./lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./lib-function-docs.nix { inherit locationsXml pkgs; };
  version = pkgs.lib.version;
in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${locationsXml} ./function-locations.xml
    ln -s ${functionDocs} ./function-docs

    ln -s ${pkgs.docbook5}/xml/rng/docbook/docbook.rng ./docbook.rng
    ln -s ${pkgs.docbook_xsl_ns}/xml/xsl ./xsl

    ln -s ${../../nixos/doc/xmlformat.conf} ./xmlformat.conf
    ln -s ${pkgs.documentation-highlighter} ./highlightjs

    echo -n "${version}" > ./version
  )
  mv result $out
''
