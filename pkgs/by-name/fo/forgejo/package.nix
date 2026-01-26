import ./generic.nix {
  version = "14.0.1";
  hash = "sha256-nnHpi2mb+QziEtahRVMUt7t+xKiylzLCalh+6ywcP7w=";
  npmDepsHash = "sha256-gyEr5uNZfBELxbvQeZ48xqtay7ObQL4dQaFO9yPC2Hg=";
  vendorHash = "sha256-7xgm57IqsFOh3CPwGybPHLLlckGLplJpU7M5upYKBl8=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
