import ./generic.nix {
  version = "16.0.2";
  hash = "sha256-cJWX77ROA9I1Y6/IEoGhm6wc2ScgKkMclpEyd4lHqew=";
  npmDepsHash = "sha256-SS9Yb4fEY9C+ddk2Omf4+v1w6Ff2ArJZd1p5XGRN2EU=";
  vendorHash = "sha256-iLzYUo+oTSiJbqp7NygfaUxZxeXYuQm1/9oTk5+n0dk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
