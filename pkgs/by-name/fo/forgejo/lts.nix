import ./generic.nix {
  version = "7.0.14";
  hash = "sha256-DtGJStiXuJl0m4K6+DNxsBBaj9dB4bEmMqpGS3WGPD4=";
  npmDepsHash = "sha256-R78/L6HS8pUNccrctBJ2E8ndS/RBHd+mTvl0JPoxr8Q=";
  vendorHash = "sha256-18tJJ3dBVR9d7PFBRFtOVVtZAcdKucmbOTXHdk7U89s=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
