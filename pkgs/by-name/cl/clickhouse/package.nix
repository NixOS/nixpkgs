import ./generic.nix {
  version = "25.9.4.58-stable";
  hash = "sha256-HRbqVSyDuvhkv0+PSgps9AXKdLlukrLA65OLx5gZ3c0=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable|.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
