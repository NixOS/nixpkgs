{
  stable = import ./browser.nix {
    channel = "stable";
    version = "121.0.2277.106";
    revision = "1";
    hash = "sha256-D0bHpz85J6R6LNWr8zaMt9vyolHYkmo9Bi4VaXCkH1U=";
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
