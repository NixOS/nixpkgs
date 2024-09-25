import ./generic.nix {
  hash = "sha256-roPBHqy5toYF0X9mATl6QYb5GGlgPoGZYOC9vKpca88=";
  version = "6.0.2";
  vendorHash = "sha256-TP1NaUpsHF54mWQDcHS4uabfRJWu3k51ANNPdA4k1Go=";
  patches = [ ];
  lts = true;
  updateScriptArgs = "--lts=true --regex '6.0.*'";
}
