{ pkgs ? (import ./.. { }), nixpkgs ? { }}:
let

  locationsXml = import ./doc-customisation/lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./doc-customisation/lib-function-docs.nix { inherit locationsXml pkgs; };

  lib = pkgs.lib;

in pkgs.nix-doc-tools
{
  name = "nixpkgs-manual";
  src = ./.;
  generated-files = [
    locationsXml
    functionDocs
  ];

  nativeBuildInputs = with pkgs; [ pandoc findutils gnumake gnused ];

  preBuild = ''
    ln -fs $(realpath ./generated/function-locations.xml) ./functions/library/locations.xml
    ln -fs $(realpath ./generated/function-docs) ./functions/library/generated

    make
  '';
}
