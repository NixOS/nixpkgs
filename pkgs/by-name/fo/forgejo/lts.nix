import ./generic.nix {
  version = "11.0.7";
  hash = "sha256-svNysySAE50rgTXTyPiZDv0lQfYGgdgoc5+9GXxv3Bw=";
  npmDepsHash = "sha256-1lY08jBTx3DRhoaup02076EL9n85y57WCsS/cNcM4aw=";
  vendorHash = "sha256-Jh8u+iCBhYdKcLj4IzcKtJBnzvclvUeYbR/hjMN+cPs=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
