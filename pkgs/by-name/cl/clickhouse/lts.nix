import ./generic.nix {
  version = "25.8.8.26-lts";
  hash = "sha256-jzgfbM0WRdbSr0OXB9t0e1BjZQwZaEwIfzg7W4Z11c0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
