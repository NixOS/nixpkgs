{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  locationsXml = import ./lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./lib-function-docs.nix { inherit locationsXml pkgs; };
in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${locationsXml} ./function-locations.xml
    ln -s ${functionDocs} ./function-docs
  )
  mv result $out
''
