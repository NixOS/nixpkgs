{
  beta = import ./browser.nix {
    channel = "beta";
    version = "122.0.2365.59";
    revision = "1";
    hash = "sha256-hs6NHAdqji5Cg1ReGWqalFHv6wyRlyclssyc0cxM+ZU=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "123.0.2420.6";
    revision = "1";
    hash = "sha256-fX6lxhJstz2cZZODu7xRe1fez8WTXqlYNgsMhIVTLaU=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "122.0.2365.59";
    revision = "1";
    hash = "sha256-LbyipfA5TZWSZu1jeUykGZ2FXwt9rZ7ak7mmryXRnMQ=";
  };
}
