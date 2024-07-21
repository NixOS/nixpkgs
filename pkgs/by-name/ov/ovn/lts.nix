import ./generic.nix {
  version = "24.03.2";
  hash = "sha256-pO37MfmvlSd/bU9cGngFEJLnXtZFTqyz1zcYLvFLrrQ=";
  updateScriptArgs = "--lts=true --regex '24.03.*'";
}
