import ./generic.nix {
  version = "25.8.2.29-lts";
  hash = "sha256-S+1fZuYlZUMkiBlMtufMT5aAi9uwbFMjYW7Dmkt/Now=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
