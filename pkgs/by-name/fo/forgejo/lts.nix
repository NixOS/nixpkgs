import ./generic.nix {
  version = "11.0.5";
  hash = "sha256-r1PR2WfJUvt+5K9RQi+9+xJmhtpqP6cGzEk77DiZUlE=";
  npmDepsHash = "sha256-1lY08jBTx3DRhoaup02076EL9n85y57WCsS/cNcM4aw=";
  vendorHash = "sha256-Jh8u+iCBhYdKcLj4IzcKtJBnzvclvUeYbR/hjMN+cPs=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
