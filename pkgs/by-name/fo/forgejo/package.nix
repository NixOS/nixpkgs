import ./generic.nix {
  version = "14.0.4";
  hash = "sha256-kw3oN/Kr+SYF1vVbStaWWV59Pw75mEeF4eUYljI1f+0=";
  npmDepsHash = "sha256-TjohWmdEZII0ti/T37kQ04Lkoy79VbY02hE1hxrWYx8=";
  vendorHash = "sha256-Dm+aZMPjrqfHSLzkd9HHTuM8wVLtGpT2Nf5frWtYW10=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
