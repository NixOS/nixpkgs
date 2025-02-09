import ./generic.nix {
  version = "7.0.13";
  hash = "sha256-mqpqxr5HE0CoDZkTIdZQEcWFywVw4HVwvPfrdXKp8tk=";
  npmDepsHash = "sha256-R78/L6HS8pUNccrctBJ2E8ndS/RBHd+mTvl0JPoxr8Q=";
  vendorHash = "sha256-FyFmuJQqe+MUjhXEoB5VlSmTLSsCVbigz4H3jaQhKrE=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
