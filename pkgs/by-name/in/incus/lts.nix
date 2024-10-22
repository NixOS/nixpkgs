import ./generic.nix {
  hash = "sha256-roPBHqy5toYF0X9mATl6QYb5GGlgPoGZYOC9vKpca88=";
  version = "6.0.2";
  vendorHash = "sha256-TP1NaUpsHF54mWQDcHS4uabfRJWu3k51ANNPdA4k1Go=";
  patches = [
    # qemu 9.1 compat, remove when added to LTS
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
  ];
  lts = true;
  updateScriptArgs = "--lts --regex '6.0.*'";
}
