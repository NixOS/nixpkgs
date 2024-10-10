{
  beta = import ./browser.nix {
    channel = "beta";
    version = "130.0.2849.27";
    revision = "1";
    hash = "sha256-LTHkKsgMKdY4ENhM+lMuUOaXIjkDa/7GPJ2p40L1x+c=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "131.0.2875.0";
    revision = "1";
    hash = "sha256-SREXT8ZsAhcDyPuTtolLrVO2fGX1ZfzifMwZS46Z+g8=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "129.0.2792.79";
    revision = "1";
    hash = "sha256-z3U8kFuDhvoHiMSNVfyW3QgfzDYvDfOqer5k25wSRic=";
  };
}
