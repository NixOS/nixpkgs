import ./generic.nix {
  version = "8.0.3";
  hash = "sha256-PvCWUiJIs9ktuJetPYZT0V8S8+OYahCDZiZQpvWWXhY=";
  npmDepsHash = "sha256-E4eq4OompY8e+722PbSFCmcarpYBpO/n9X6GVU9AhDU=";
  vendorHash = "sha256-4l4kscwesW/cR8mZjE3G9HcVm0d1ukxbtBY6RXYRi8k=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
