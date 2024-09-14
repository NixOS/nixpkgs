{
  beta = import ./browser.nix {
    channel = "beta";
    version = "129.0.2792.21";
    revision = "1";
    hash = "sha256-NrDRroKyjY9zC9KoMWaEPAPnu+JNNDZwLVbuDvoUG1M=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "130.0.2808.0";
    revision = "1";
    hash = "sha256-6mqStxS9HJvfKbrGqQGlqQKXc2SnvOycirPihfnkaLI=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "128.0.2739.67";
    revision = "1";
    hash = "sha256-Y8PxyAibuEhwKJpqnhtBy1F2Kn+ONw6NVtC25R+fFVo=";
  };
}
