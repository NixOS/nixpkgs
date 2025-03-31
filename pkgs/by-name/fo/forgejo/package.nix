import ./generic.nix {
  version = "10.0.3";
  hash = "sha256-bt1lgp6UiZeiZiIN3vZZbUygHVX1lEE5uOkPXrjk68o=";
  npmDepsHash = "sha256-e3SE6cu1xCBdoMRqp2Gcjcay/EwjF+bTdPOlpL1STvw=";
  vendorHash = "sha256-b3+zxsKRylgfdW0Yiz0QryObMKdtiMCt0hB3DtAGFrQ=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
