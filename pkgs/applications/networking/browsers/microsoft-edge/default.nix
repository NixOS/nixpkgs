{
  beta = import ./browser.nix {
    channel = "beta";
    version = "125.0.2535.13";
    revision = "1";
    hash = "sha256-vO7crYX/QW+S1fjT37JtyRJyziauG+H3LWOasX4VaKM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "126.0.2552.0";
    revision = "1";
    hash = "sha256-TQHTqCweP0mEkEYRxlU7YtYS6Y6ooZ4V6peCsVvcIjg=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "124.0.2478.80";
    revision = "1";
    hash = "sha256-p+t12VcwxSDuyZj3VfzEJ6m0rGoVC7smeyHoODttwQU=";
  };
}
