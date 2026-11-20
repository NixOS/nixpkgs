import ./generic.nix {
  version = "17.0.2";
  hash = "sha256-IKC/Pw4LyKC5xXlcaGuCMMsnojMIpQXvXX75bbLpVPI=";
  npmDepsHash = "sha256-AkDV0GPdoqjnvrDkMHn6VJVYVGIwvuPk5dv/HxUHD8Q=";
  vendorHash = "sha256-clgLfIfTLdy61casS11MifItA7o+Sp24Bq7093Fw4xY=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
