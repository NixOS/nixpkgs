import ./generic.nix {
  version = "25.9.2.1-stable";
  hash = "sha256-BygRxiDhhs91/UPWY7f3jAGyTtyAj98RdDXLwjs8Abo=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable|.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
