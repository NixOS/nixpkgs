{
  stable = import ./browser.nix {
    channel = "stable";
    version = "121.0.2277.113";
    revision = "1";
    hash = "sha256-VbWM0xC9OlumTf3lBhjd5tdkIx2SGQPf3rhin+rrQvA=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "122.0.2365.16";
    revision = "1";
    hash = "sha256-SeLX7UibXd1nOhxWwMuUTCKK4GkN2TmJPesWhLwCD6A=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "123.0.2380.1";
    revision = "1";
    hash = "sha256-SBlHXURiPoC5Q7wi67tgnuV2PUw4ffniGq6kmOZtIf0=";
  };
}
