import ./generic.nix {
  version = "25.7.1.3997-stable";
  hash = "sha256-XEVAQrANEIXim1MlOAYEmfwyomGrvsS/mbSKggMkr1k=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
