import ./generic.nix {
  version = "22.03.7";
  hash = "sha256-HzVzJN1QnMTlv39I7clzciJD/Owm93jFO4qfaE1k6e4=";
  updateScriptArgs = "--lts=true --regex '22.03.*'";
}
