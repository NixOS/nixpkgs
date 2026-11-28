import ./generic.nix {
  hash = "sha256-00qJ5OFGET00/8jTz2a+8lnQsvvFPxn0YBidAgP9mEI=";
  version = "7.7.0";
  vendorHash = "sha256-dPzySn5BTeGXpWnoM8wS4DcOQM+LE51aUi4eoZoWWkc=";
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
