import ./generic.nix {
  version = "25.8.2.29-lts";
  hash = "sha256-S+1fZuYlZUMkiBlMtufMT5aAi9uwbFMjYW7Dmkt/Now=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable|.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
