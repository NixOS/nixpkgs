{
  beta = import ./browser.nix {
    channel = "beta";
    version = "99.0.1150.16";
    revision = "1";
    sha256 = "sha256:0qsgs889d6qwxz9qf42psmjqfhmrqgp07srq5r38npl5pncr137h";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "100.0.1163.1";
    revision = "1";
    sha256 = "sha256:153faqxyw5f5b6cqnvd71dl7941znkzci8dwbcgaxway0b6882jq";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "98.0.1108.56";
    revision = "1";
    sha256 = "sha256:03jbj2s2fs60fzfgsmyb284q7nckji87qgb86mvl5g0hbl19aza7";
  };
}
