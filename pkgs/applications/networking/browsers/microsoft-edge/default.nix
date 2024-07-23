{
  beta = import ./browser.nix {
    channel = "beta";
    version = "127.0.2651.61";
    revision = "1";
    hash = "sha256-M67QOKZF4+dGCdyKfe5EF5K4A6bip2/a4J1k7+v3QMQ=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "128.0.2708.0";
    revision = "1";
    hash = "sha256-QFtVQTcbiF165/Xqmo8kAoo4kQegqqzMVcr8mQiraH8=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "126.0.2592.113";
    revision = "1";
    hash = "sha256-wSNXCUTG9eCnqe5Ir8pE8Z7zuY2KsDgTLKKTAQeXS2s=";
  };
}
