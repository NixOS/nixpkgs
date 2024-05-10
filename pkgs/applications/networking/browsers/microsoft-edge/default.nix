{
  beta = import ./browser.nix {
    channel = "beta";
    version = "124.0.2478.51";
    revision = "1";
    hash = "sha256-qQTRPkQBLRZhOqBT8U0PGcmmR2zNRxJiFl3N2UPwoSo=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "125.0.2518.0";
    revision = "1";
    hash = "sha256-q4TVpO0SxSSLMv/NtmJIOzClT2WqUss2qfE5vgj4O7E=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "124.0.2478.51";
    revision = "1";
    hash = "sha256-dAiTS+KvKVwL6tNp4YsQfH4wdNIJoBJngcLBXgHArjE=";
  };
}
