import ./generic.nix {
  version = "25.8.10.7-lts";
  hash = "sha256-EOZ2AfeBeXAWQqa25eQX3loE+xegt03lsCU1aQt/Ebs=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable|.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
