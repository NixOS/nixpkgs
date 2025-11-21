{
  lib,
  buildVimPlugin,
  nodePackages,
}:
final: prev:
let
  nodePackageNames = [
    # # keep-sorted start case=no
    "coc-go"
    "coc-tsserver"
    # keep-sorted end
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
