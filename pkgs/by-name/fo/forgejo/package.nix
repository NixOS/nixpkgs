import ./generic.nix {
  version = "13.0.0";
  hash = "sha256-8NRUJpf25Bai0NtzYf2APmOt3rqpP9mPM13KMjNLl2M=";
  npmDepsHash = "sha256-7WjcMsKPtKUWJfDrJc65ZXq2tjK8+8DnqwINj+0XyiQ=";
  vendorHash = "sha256-PHItbU27d9ouykUlhr9owylMpF+3wz2vc8c0UTR1RVU=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
