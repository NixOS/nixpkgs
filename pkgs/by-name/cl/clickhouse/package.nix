import ./generic.nix {
  version = "25.7.4.11-stable";
  hash = "sha256-SKDnnBdl9Rwc+ONH1chXAOFIwRmVG2l5cPEwpaDogzU=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
