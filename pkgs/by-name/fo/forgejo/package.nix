import ./generic.nix {
  version = "10.0.1";
  hash = "sha256-JLy/edAkbsOqQTQqqoyxc0UX9fPnP8HD54IUzcsyGe4=";
  npmDepsHash = "sha256-e3SE6cu1xCBdoMRqp2Gcjcay/EwjF+bTdPOlpL1STvw=";
  vendorHash = "sha256-fqHwqpIetX2jTAWAonRWqF1tArL7Ik/XXURY51jGOn0=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
