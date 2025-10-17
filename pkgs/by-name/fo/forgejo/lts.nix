import ./generic.nix {
  version = "11.0.6";
  hash = "sha256-7rX0B1db0HbZa/em3hX+yzAi4rqsDysJPx3dIInGxpY=";
  npmDepsHash = "sha256-1lY08jBTx3DRhoaup02076EL9n85y57WCsS/cNcM4aw=";
  vendorHash = "sha256-Jh8u+iCBhYdKcLj4IzcKtJBnzvclvUeYbR/hjMN+cPs=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
