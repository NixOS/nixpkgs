import ./generic.nix {
  version = "25.8.10.7-lts";
  hash = "sha256-EOZ2AfeBeXAWQqa25eQX3loE+xegt03lsCU1aQt/Ebs=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
