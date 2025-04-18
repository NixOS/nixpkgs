import ./generic.nix {
  version = "11.0.0";
  hash = "sha256-j/SmfWFfYDApqGXcH/gRF6c7gUCTkLYFTglgtdq9u/U=";
  npmDepsHash = "sha256-laHHXq59/7+rJSYTD1Aq/AvFcio6vsnWkeV8enq3yTg=";
  vendorHash = "sha256-REHrSuvAB5fbJ1WR+rggGZUSMy0FWnAkQQbTIqN2K2E=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
