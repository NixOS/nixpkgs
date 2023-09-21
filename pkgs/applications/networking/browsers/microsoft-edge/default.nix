{
  stable = import ./browser.nix {
    channel = "stable";
    version = "116.0.1938.76";
    revision = "1";
    sha256 = "sha256-zSnNgnpsxR2sRgoG+Vi2K3caaVUPLiJJ9d+EjjIzu7Y=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "117.0.2045.21";
    revision = "1";
    sha256 = "sha256-vsZy9WGlT4Yqf/tHmsgZV8Pj7D0nmhmziKYGrRj7Bi0=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "118.0.2060.1";
    revision = "1";
    sha256 = "sha256-OKjCmULPjYuoumqAqivyCFzHSR1IOutEIWTqXtDgMhM=";
  };
}
