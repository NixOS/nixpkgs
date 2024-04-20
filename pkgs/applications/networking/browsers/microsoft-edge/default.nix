{
  beta = import ./browser.nix {
    channel = "beta";
    version = "124.0.2478.39";
    revision = "1";
    hash = "sha256-0KQU/JS6hlv2SLMB8RKyITUiodByBUstrhcwIefn3Yw=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "125.0.2518.0";
    revision = "1";
    hash = "sha256-q4TVpO0SxSSLMv/NtmJIOzClT2WqUss2qfE5vgj4O7E=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "123.0.2420.97";
    revision = "1";
    hash = "sha256-q7Pcbi0JQr/wvKIrgueD9f2Z6v1DMoD2bcRJKGqDYjs=";
  };
}
