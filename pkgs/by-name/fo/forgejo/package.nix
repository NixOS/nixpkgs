import ./generic.nix {
  version = "14.0.0";
  hash = "sha256-kQaaRwVUYIYTTjWcHKb09CzygDR6lhEbnY3FOsnyYpg=";
  npmDepsHash = "sha256-rdlVXdoov3zppDgoLODl22AKCdm+AXiV1O63dmo6trg=";
  vendorHash = "sha256-7xgm57IqsFOh3CPwGybPHLLlckGLplJpU7M5upYKBl8=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
