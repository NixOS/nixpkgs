import ./generic.nix {
  hash = "sha256-+q5qP7w2RdtuwvxPThCryYYEJ7s5WDnWHRvjo4TuajA=";
  version = "6.0.0";
  vendorHash = "sha256-wcauzIbBcYpSWttZCVVE9m49AEQGolGYSsv9eEkhb7Y=";
  patches = [ ];
  lts = true;
  updateScriptArgs = "--lts=true --regex '6.0.*'";
}
