import ./generic.nix {
  hash = "sha256-DgPSH5t1Zx2X9T8dbpz54M5nXNcCJbdfcq9AEd8kmYo=";
  version = "6.0.6";
  vendorHash = "sha256-bVJwg9VaiSgfpKo+e2oMsYgmaKk42dktq0pahcfbjp0=";
  patches = [
    # qemu 9.1 compat, remove when added to LTS
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
  ];
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(6\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
