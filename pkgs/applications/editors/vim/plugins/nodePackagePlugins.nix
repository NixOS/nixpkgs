{
  lib,
  buildVimPlugin,
  nodePackages,
}:
final: prev:
let
  nodePackageNames = [
    "coc-go"
    "coc-ltex"
    "coc-tsserver"
    "coc-ultisnips"
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
