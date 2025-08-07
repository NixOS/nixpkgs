import ./generic.nix {
  version = "25.7.2.54-stable";
  hash = "sha256-WwrElYPSgcQGGpJ0gUqVrynLQx/kQHHmrTsckiRFm4w=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
