import ./generic.nix {
  version = "16.0.3";
  hash = "sha256-G2kp2k/ivqxXG68+piBczXujtj3f/fLr+DnHoiMKOB4=";
  npmDepsHash = "sha256-QwZ8X0pVxs5u4jMOqy3VGcBGVqqDKpLCMPmwoECVwEg=";
  vendorHash = "sha256-0nvMy0oyVIy2qBngg1eu0UAGBEuoCGzDdsBYUuU/A48=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
