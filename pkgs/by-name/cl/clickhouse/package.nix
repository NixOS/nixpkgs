import ./generic.nix {
  version = "25.7.5.34-stable";
  hash = "sha256-0+e2QPsn6EZ28j3HE2TYOpJBN9jSl19Ytbvj+124viw=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
