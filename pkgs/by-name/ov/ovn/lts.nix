import ./generic.nix {
  version = "22.03.5";
  hash = "sha256-DMDWR7Dbgak0azPcVqDdFHGovTbLX8byp+jQ3rYvvX4=";
  updateScriptArgs = "--lts=true --regex '22.03.*'";
}
