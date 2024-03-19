{
  beta = import ./browser.nix {
    channel = "beta";
    version = "123.0.2420.41";
    revision = "1";
    hash = "sha256-tWsd+RyGJp+/1Sf4yDrq4EbLfaYsLkm4wLj9rfWmPlE=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "124.0.2450.2";
    revision = "1";
    hash = "sha256-9PRQnnTYhArwRcTxuCufM7JcAcr6K7jKeFCrOsarCh0=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "122.0.2365.92";
    revision = "1";
    hash = "sha256-6rEVxFS2advEL4O2uczJTsTy31os9r52IGnHXxj3A+g=";
  };
}
