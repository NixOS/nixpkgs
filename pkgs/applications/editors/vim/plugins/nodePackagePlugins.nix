{
  lib,
  buildVimPlugin,
  nodePackages,
}:
final: prev:
let
  nodePackageNames = [
    "coc-go"
    "coc-tsserver"
  ];
in
lib.genAttrs nodePackageNames (
  name:
  buildVimPlugin {
    pname = name;
    inherit (nodePackages.${name}) version meta;
    src = "${nodePackages.${name}}/lib/node_modules/${name}";
  }
)
