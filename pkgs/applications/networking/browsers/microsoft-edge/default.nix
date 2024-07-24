{
  beta = import ./browser.nix {
    channel = "beta";
    version = "127.0.2651.49";
    revision = "1";
    hash = "sha256-fMB7CuC5u8RNbbtFEZWFIIBwZTPkTP9LVs7DCXltGEA=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "128.0.2677.1";
    revision = "1";
    hash = "sha256-aKrNs44FZNhC/fGT1UvyE2Fx8Q53ahAu91Bu86E49o8=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "126.0.2592.102";
    revision = "1";
    hash = "sha256-xCjtsZoetxlOV77VSbt09cGbpfHUYhTA6WXuZAvD/a4=";
  };
}
