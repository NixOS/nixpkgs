{
  stable = import ./browser.nix {
    channel = "stable";
    version = "121.0.2277.128";
    revision = "1";
    hash = "sha256-ooZzTDmddlYwWoDMqzFPfbUImT351/ptfdlxKEtI77s=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "122.0.2365.38";
    revision = "1";
    hash = "sha256-u0qk4T695LyhtfMw5929z4U8+jM2o/gbq8DFtD1PNTU=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "123.0.2400.1";
    revision = "1";
    hash = "sha256-I9PT320DJgqJYNwB0pvngyLlV+N2jaS5tOwVwwNHex0=";
  };
}
