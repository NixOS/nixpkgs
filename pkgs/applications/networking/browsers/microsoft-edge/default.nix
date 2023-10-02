{
  stable = import ./browser.nix {
    channel = "stable";
    version = "117.0.2045.47";
    revision = "1";
    sha256 = "sha256-h4iw+H8f62JEih1tWTpjxNC9+wu3hHQOM2VJid1kHNQ=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "118.0.2088.17";
    revision = "1";
    sha256 = "sha256-3Z37M2ZQRJ5uA7NcinMlF1XEsYVv9A+ppPZZf34ye6Q=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "119.0.2116.0";
    revision = "1";
    sha256 = "sha256-raLRFSHZyHaxKi6EG62VIbcW29HTjTnBFw7IJFVbm5I=";
  };
}
