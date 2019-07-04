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

    echo -n "${version}" > ./version
  )
  mv result $out
''
