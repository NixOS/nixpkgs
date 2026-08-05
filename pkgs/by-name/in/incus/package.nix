import ./generic.nix {
  hash = "sha256-5XOpT+MnLcPrINHD9VAjDtXSeYAqIsejuOsOpQLMfwc=";
  version = "7.3.0";
  vendorHash = "sha256-FZ9oVHrZNE/h1w/qWNTdN9/zfn9r6S3ox0W2YKf6hgI=";
  patches = fetchpatch2: [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
