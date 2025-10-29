import ./generic.nix {
  version = "25.8.11.66-lts";
  hash = "sha256-VUdT5STQqcWevYJjtuLdTeDGZHNl3JkkDSgcckjSZbw=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable|.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
