import ./generic.nix {
  version = "25.6.5.41-stable";
  hash = "sha256-NIt5JCKXSnJRSjCZskMvRhN8qwCB0aKinOCKXqq5DF0=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
