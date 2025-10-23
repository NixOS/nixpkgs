{
  lib,
  buildVimPlugin,
  nodePackages,
}:
final: prev:
let
  nodePackageNames = [
    "coc-cmake"
    "coc-emmet"
    "coc-eslint"
    "coc-flutter"
    "coc-go"
    "coc-haxe"
    "coc-highlight"
    "coc-html"
    "coc-java"
    "coc-jest"
    "coc-json"
    "coc-lists"
    "coc-ltex"
    "coc-markdownlint"
    "coc-pairs"
    "coc-prettier"
    "coc-r-lsp"
    "coc-rust-analyzer"
    "coc-smartf"
    "coc-snippets"
    "coc-solargraph"
    "coc-sqlfluff"
    "coc-stylelint"
    "coc-sumneko-lua"
    "coc-tabnine"
    "coc-texlab"
    "coc-tsserver"
    "coc-ultisnips"
    "coc-vimlsp"
    "coc-vimtex"
    "coc-wxml"
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
