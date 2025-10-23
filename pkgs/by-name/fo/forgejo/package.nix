import ./generic.nix {
  version = "13.0.1";
  hash = "sha256-P8ZIBV0pVo3cn9Yroe67Bt+/7KEdz/gBGSypmUz5V2g=";
  npmDepsHash = "sha256-7WjcMsKPtKUWJfDrJc65ZXq2tjK8+8DnqwINj+0XyiQ=";
  vendorHash = "sha256-PHItbU27d9ouykUlhr9owylMpF+3wz2vc8c0UTR1RVU=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
