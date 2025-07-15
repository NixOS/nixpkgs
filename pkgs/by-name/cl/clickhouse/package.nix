import ./generic.nix {
  version = "25.6.4.12-stable";
  hash = "sha256-37huf+eOMOUJg7pyoFPzCTlUilI3wnq8D6tcrhC0NUE=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
