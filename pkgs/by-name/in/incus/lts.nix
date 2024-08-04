import ./generic.nix {
  hash = "sha256-8GgzMiXn/78HkMuJ49cQA9BEQVAzPbG7jOxTScByR6Q=";
  version = "6.0.1";
  vendorHash = "sha256-dFg3LSG/ao73ODWcPDq5s9xUjuHabCMOB2AtngNCrlA=";
  patches = [ ];
  lts = true;
  updateScriptArgs = "--lts=true --regex '6.0.*'";
}
