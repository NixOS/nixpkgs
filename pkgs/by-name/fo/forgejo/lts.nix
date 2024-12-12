import ./generic.nix {
  version = "7.0.12";
  hash = "sha256-8rX/w4EqZwbs1xaHEkwN02+PQQD7e9VAXVrCqYwm3o0=";
  npmDepsHash = "sha256-suPR7qcxXuK8AJfk47EcQRWtSo5V3jad4Ci122lbBR0=";
  vendorHash = "sha256-seC8HzndQ10LecU+ii3kCO3ZZeCc3lqAujWbMKwNbpI=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "v(7\.[0-9.]+)"
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
