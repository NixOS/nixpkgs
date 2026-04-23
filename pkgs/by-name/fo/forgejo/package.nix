import ./generic.nix {
  version = "15.0.0";
  hash = "sha256-KAGHascGFj4X6b4BpRqQ8yCedNh0nvHfQgbzJh9fxAc=";
  npmDepsHash = "sha256-AWvLcAS7EEy796kAQfiQ8sFSh/s+6zNCJEqe4qzQL3s=";
  vendorHash = "sha256-bP7cykWKwNQrWm9jJT4YYAHRV66HaTwGkvhBqSHgWAA=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
