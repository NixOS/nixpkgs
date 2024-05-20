{
  beta = import ./browser.nix {
    channel = "beta";
    version = "125.0.2535.37";
    revision = "1";
    hash = "sha256-/fZcFIVj4stIxim2UYsxA5rNkyGf/i3eDf25npsdDi4=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "126.0.2566.1";
    revision = "1";
    hash = "sha256-PePosWGdkLm5OK82YP9LQbvVz5de8KL06I6rv0TKP3A=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "124.0.2478.97";
    revision = "1";
    hash = "sha256-hdCtHWOEez3VTw8hTRiitURiu0MpFTbnc60biym795k=";
  };
}
