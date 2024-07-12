{
  beta = import ./browser.nix {
    channel = "beta";
    version = "127.0.2651.31";
    revision = "1";
    hash = "sha256-SERogsWM4mtIEVAVtwaRu2VOjK012yWBb2FygDfKO80=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "128.0.2677.1";
    revision = "1";
    hash = "sha256-aKrNs44FZNhC/fGT1UvyE2Fx8Q53ahAu91Bu86E49o8=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "126.0.2592.87";
    revision = "1";
    hash = "sha256-ntcewiAc/hDUF9wiURCXm8TxqatvEPXaTUn8kblzK0o=";
  };
}
