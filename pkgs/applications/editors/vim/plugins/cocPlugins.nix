{
  lib,
  buildVimPlugin,
  pkgs,
  coc-nginx,
}:
final: prev:
let
  cocPackages = [
    # keep-sorted start
    "coc-basedpyright"
    "coc-clangd"
    "coc-cmake"
    "coc-css"
    "coc-diagnostic"
    "coc-docker"
    "coc-emmet"
    "coc-eslint"
    "coc-explorer"
    "coc-flutter"
    "coc-git"
    "coc-haxe"
    "coc-highlight"
    "coc-html"
    "coc-java"
    "coc-jest"
    "coc-json"
    "coc-lists"
    "coc-markdownlint"
    "coc-pairs"
    "coc-prettier"
    "coc-pyright"
    "coc-r-lsp"
    "coc-rust-analyzer"
    "coc-sh"
    "coc-smartf"
    "coc-snippets"
    "coc-solargraph"
    "coc-spell-checker"
    "coc-sqlfluff"
    "coc-stylelint"
    "coc-sumneko-lua"
    "coc-tabnine"
    "coc-texlab"
    "coc-toml"
    "coc-vimlsp"
    "coc-vimtex"
    "coc-wxml"
    "coc-yaml"
    "coc-yank"
    # keep-sorted end
  ];
in
lib.genAttrs cocPackages (
  pkg:
  let
    cocPkg = pkgs.${pkg};
  in
  buildVimPlugin {
    inherit (cocPkg) pname version meta;
    src = "${cocPkg}/lib/node_modules/${cocPkg.pname}";
  }
)
// {
  coc-nginx = buildVimPlugin {
    inherit (coc-nginx) pname version meta;
    src = "${coc-nginx}/lib/node_modules/@yaegassy/coc-nginx";
  };
}
