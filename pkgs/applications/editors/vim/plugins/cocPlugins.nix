{
  buildVimPlugin,
  coc-clangd,
  coc-css,
  coc-diagnostic,
  coc-pyright,
  coc-toml,
}:
final: prev: {
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

  coc-pyright = buildVimPlugin {
    pname = "coc-pyright";
    inherit (coc-pyright) version meta;
    src = "${coc-pyright}/lib/node_modules/coc-pyright";
  };

  coc-toml = buildVimPlugin {
    pname = "coc-toml";
    inherit (coc-toml) version meta;
    src = "${coc-toml}/lib/node_modules/coc-toml";
  };
}
