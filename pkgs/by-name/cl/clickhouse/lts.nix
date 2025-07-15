import ./generic.nix {
  version = "25.3.6.56-lts";
  hash = "sha256-wpC6uw811IWImLWAatYbghp3aZ+esEEBFng6AHIesK4=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
