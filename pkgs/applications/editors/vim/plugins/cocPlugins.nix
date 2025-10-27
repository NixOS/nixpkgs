{
  buildVimPlugin,
  coc-basedpyright,
  coc-clangd,
  coc-css,
  coc-diagnostic,
  coc-docker,
  coc-explorer,
  coc-git,
  coc-pyright,
  coc-sh,
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

  coc-explorer = buildVimPlugin {
    inherit (coc-explorer) pname version meta;
    src = "${coc-explorer}/lib/node_modules/coc-explorer";
  };

  coc-git = buildVimPlugin {
    inherit (coc-git) pname version meta;
    src = "${coc-git}/lib/node_modules/coc-git";
  };

  coc-pyright = buildVimPlugin {
    pname = "coc-pyright";
    inherit (coc-pyright) version meta;
    src = "${coc-pyright}/lib/node_modules/coc-pyright";
  };

  coc-sh = buildVimPlugin {
    pname = "coc-sh";
    inherit (coc-sh) version meta;
    src = "${coc-sh}/lib/node_modules/coc-sh";
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
