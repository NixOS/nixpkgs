{
  beta = import ./browser.nix {
    channel = "beta";
    version = "130.0.2849.5";
    revision = "1";
    hash = "sha256-chvB84+zu6/xgRHyUk33aicc44QJLxxdOOu0ngqmsFM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "130.0.2849.1";
    revision = "1";
    hash = "sha256-JObqtaaUR6J4rZ90WWw7Ku5Ntl/QBWHo23T7Ohu5p1s=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "129.0.2792.65";
    revision = "1";
    hash = "sha256-xuCtHptE2CG4aiY7gu2sWW3Km4qfB0E/L/PBACIaKOc=";
  };
}
