{
  stable = import ./browser.nix {
    channel = "stable";
    version = "121.0.2277.98";
    revision = "1";
    hash = "sha256-vm0aBWiGtjdSu55nCNuhbqn4XVI6l/BxwmpTlTHWt/M=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "122.0.2365.8";
    revision = "1";
    hash = "sha256-1qM61lO7LyX7CuLrKsEuciud7BuDxRKNyQahdFJhq+g=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "122.0.2365.3";
    revision = "1";
    hash = "sha256-O2SxGzcvNloxLbexDjA0C28w7EJi1Fl9IUnI1zc1S6Y=";
  };
}
