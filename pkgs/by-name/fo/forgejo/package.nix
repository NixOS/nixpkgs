import ./generic.nix {
  version = "13.0.2";
  hash = "sha256-5am/WiRo+ma2ArhnKxQ6cpFl2q7R4g4UwtdnSY/+RIM=";
  npmDepsHash = "sha256-7WjcMsKPtKUWJfDrJc65ZXq2tjK8+8DnqwINj+0XyiQ=";
  vendorHash = "sha256-PHItbU27d9ouykUlhr9owylMpF+3wz2vc8c0UTR1RVU=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
