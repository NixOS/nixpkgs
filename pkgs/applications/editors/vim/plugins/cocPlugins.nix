{
  buildVimPlugin,
  coc-basedpyright,
  coc-clangd,
  coc-cmake,
  coc-css,
  coc-diagnostic,
  coc-docker,
  coc-emmet,
  coc-eslint,
  coc-explorer,
  coc-flutter,
  coc-git,
  coc-haxe,
  coc-highlight,
  coc-html,
  coc-java,
  coc-jest,
  coc-json,
  coc-lists,
  coc-markdownlint,
  coc-pairs,
  coc-prettier,
  coc-pyright,
  coc-r-lsp,
  coc-rust-analyzer,
  coc-sh,
  coc-smartf,
  coc-snippets,
  coc-solargraph,
  coc-spell-checker,
  coc-toml,
}:
final: prev: {
  coc-basedpyright = buildVimPlugin {
    inherit (coc-basedpyright) pname version meta;
    src = "${coc-basedpyright}/lib/node_modules/coc-basedpyright";
  };

  coc-clangd = buildVimPlugin {
    inherit (coc-clangd) pname version meta;
    src = "${coc-clangd}/lib/node_modules/coc-clangd";
  };

  coc-cmake = buildVimPlugin {
    inherit (coc-cmake) pname version meta;
    src = "${coc-cmake}/lib/node_modules/coc-cmake";
  };

  coc-css = buildVimPlugin {
    inherit (coc-css) pname version meta;
    src = "${coc-css}/lib/node_modules/coc-css";
  };

  coc-diagnostic = buildVimPlugin {
    inherit (coc-diagnostic) pname version meta;
    src = "${coc-diagnostic}/lib/node_modules/coc-diagnostic";
  };

  coc-docker = buildVimPlugin {
    inherit (coc-docker) pname version meta;
    src = "${coc-docker}/lib/node_modules/coc-docker";
  };

  coc-emmet = buildVimPlugin {
    inherit (coc-emmet) pname version meta;
    src = "${coc-emmet}/lib/node_modules/coc-emmet";
  };

  coc-eslint = buildVimPlugin {
    inherit (coc-eslint) pname version meta;
    src = "${coc-eslint}/lib/node_modules/coc-eslint";
  };

  coc-explorer = buildVimPlugin {
    inherit (coc-explorer) pname version meta;
    src = "${coc-explorer}/lib/node_modules/coc-explorer";
  };

  coc-flutter = buildVimPlugin {
    inherit (coc-flutter) pname version meta;
    src = "${coc-flutter}/lib/node_modules/coc-flutter";
  };

  coc-git = buildVimPlugin {
    inherit (coc-git) pname version meta;
    src = "${coc-git}/lib/node_modules/coc-git";
  };

  coc-haxe = buildVimPlugin {
    inherit (coc-haxe) pname version meta;
    src = "${coc-haxe}/lib/node_modules/coc-haxe";
  };

  coc-highlight = buildVimPlugin {
    inherit (coc-highlight) pname version meta;
    src = "${coc-highlight}/lib/node_modules/coc-highlight";
  };

  coc-html = buildVimPlugin {
    inherit (coc-html) pname version meta;
    src = "${coc-html}/lib/node_modules/coc-html";
  };

  coc-java = buildVimPlugin {
    inherit (coc-java) pname version meta;
    src = "${coc-java}/lib/node_modules/coc-java";
  };

  coc-jest = buildVimPlugin {
    inherit (coc-jest) pname version meta;
    src = "${coc-jest}/lib/node_modules/coc-jest";
  };

  coc-json = buildVimPlugin {
    inherit (coc-json) pname version meta;
    src = "${coc-json}/lib/node_modules/coc-json";
  };

  coc-lists = buildVimPlugin {
    inherit (coc-lists) pname version meta;
    src = "${coc-lists}/lib/node_modules/coc-lists";
  };

  coc-markdownlint = buildVimPlugin {
    inherit (coc-markdownlint) pname version meta;
    src = "${coc-markdownlint}/lib/node_modules/coc-markdownlint";
  };

  coc-pairs = buildVimPlugin {
    inherit (coc-pairs) pname version meta;
    src = "${coc-pairs}/lib/node_modules/coc-pairs";
  };

  coc-prettier = buildVimPlugin {
    inherit (coc-prettier) pname version meta;
    src = "${coc-prettier}/lib/node_modules/coc-prettier";
  };

  coc-pyright = buildVimPlugin {
    pname = "coc-pyright";
    inherit (coc-pyright) version meta;
    src = "${coc-pyright}/lib/node_modules/coc-pyright";
  };

  coc-r-lsp = buildVimPlugin {
    inherit (coc-r-lsp) pname version meta;
    src = "${coc-r-lsp}/lib/node_modules/coc-r-lsp";
  };

  coc-rust-analyzer = buildVimPlugin {
    inherit (coc-rust-analyzer) pname version meta;
    src = "${coc-rust-analyzer}/lib/node_modules/coc-rust-analyzer";
  };

  coc-sh = buildVimPlugin {
    pname = "coc-sh";
    inherit (coc-sh) version meta;
    src = "${coc-sh}/lib/node_modules/coc-sh";
  };

  coc-smartf = buildVimPlugin {
    inherit (coc-smartf) pname version meta;
    src = "${coc-smartf}/lib/node_modules/coc-smartf";
  };

  coc-snippets = buildVimPlugin {
    inherit (coc-snippets) pname version meta;
    src = "${coc-snippets}/lib/node_modules/coc-snippets";
  };

  coc-solargraph = buildVimPlugin {
    inherit (coc-solargraph) pname version meta;
    src = "${coc-solargraph}/lib/node_modules/coc-solargraph";
  };

  coc-spell-checker = buildVimPlugin {
    pname = "coc-spell-checker";
    inherit (coc-spell-checker) version meta;
    src = "${coc-spell-checker}/lib/node_modules/coc-spell-checker";
  };

  coc-toml = buildVimPlugin {
    pname = "coc-toml";
    inherit (coc-toml) version meta;
    src = "${coc-toml}/lib/node_modules/coc-toml";
  };
}
