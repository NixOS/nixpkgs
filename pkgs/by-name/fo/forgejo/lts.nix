import ./generic.nix {
  version = "7.0.15";
  hash = "sha256-0kwp15tXh0ETCa5rJt+n5CUMnhAUfsI9/f4IgreHzI0=";
  npmDepsHash = "sha256-R78/L6HS8pUNccrctBJ2E8ndS/RBHd+mTvl0JPoxr8Q=";
  vendorHash = "sha256-rPI6ZhqGP3Q1LsvTD2AGhtJjd5eqs9zK/o1S3XlQ5vw=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "v(7\\.[0-9.]+)"
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
