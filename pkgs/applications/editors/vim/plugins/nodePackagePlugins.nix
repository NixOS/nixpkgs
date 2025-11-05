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
    "coc-yaml"
    "coc-yank"
    "coc-nginx"
  ];

  packageNameOverrides = {
    "coc-nginx" = "@yaegassy/coc-nginx";
  };

  getPackageName = name: packageNameOverrides.${name} or name;
in
lib.genAttrs nodePackageNames (
  name:
  buildVimPlugin {
    pname = name;
    inherit (nodePackages.${getPackageName name}) version meta;
    src = "${nodePackages.${getPackageName name}}/lib/node_modules/${getPackageName name}";
  }
)
