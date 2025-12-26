import ./generic.nix {
  hash = "sha256-B29HLuw48j7/Er7p/sHen7ohbbACsAjzPr9Nn8eZNR0=";
  version = "6.0.5";
  vendorHash = "sha256-KOJqPvp+w7G505ZMJ1weRD2SATmfq1aeyCqmbJ6WMAY=";
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
