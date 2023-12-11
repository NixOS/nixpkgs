{
  stable = import ./browser.nix {
    channel = "stable";
    version = "119.0.2151.72";
    revision = "1";
    hash = "sha256-thBx/+6thNXXKppA11IOG5EiMx7pA9FA3vSkwa9+F0o=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "120.0.2210.22";
    revision = "1";
    hash = "sha256-GayVVZbtGLQmmXu+k4wdsD+rPwGiSPHnQwzVYyKWhHM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "121.0.2220.3";
    revision = "1";
    hash = "sha256-M3r+SLp3lQ7oWDYoM7aNZDC5wbMxFZggsu0Iuyyw/cw=";
  };
}
