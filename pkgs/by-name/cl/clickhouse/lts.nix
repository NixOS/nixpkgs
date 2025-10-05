import ./generic.nix {
  version = "25.8.7.3-lts";
  hash = "sha256-wH/UxMgnsK6OIGxEv9CYA67f8PWC0u6IAiW2iY/KThk=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
