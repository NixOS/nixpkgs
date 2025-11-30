import ./generic.nix {
  version = "13.0.3";
  hash = "sha256-ViqwTEVZkccNx5Pt+lrWvAqzD5RRTzwfBhUTfWyDhtE=";
  npmDepsHash = "sha256-7WjcMsKPtKUWJfDrJc65ZXq2tjK8+8DnqwINj+0XyiQ=";
  vendorHash = "sha256-gHdggzCJlYvs8JXs4CJ/AyqYMPCC2o4uRwDiem3rNFM=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
