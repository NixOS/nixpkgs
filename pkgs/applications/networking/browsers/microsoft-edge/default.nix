{
  beta = import ./browser.nix {
    channel = "beta";
    version = "126.0.2592.36";
    revision = "1";
    hash = "sha256-u9gcTjener35uKt99T27+LK0A4SYNdWCW5FSHWEnaNA=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "127.0.2620.3";
    revision = "1";
    hash = "sha256-x5reGA7XZTN3FsCHf7oXstltCDSVANR8VegIuO201qs=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "125.0.2535.85";
    revision = "1";
    hash = "sha256-4GD/1jAw+nIwI5AOwrkuPNF5zAnnzje9oEQnaHOapPg=";
  };
}
