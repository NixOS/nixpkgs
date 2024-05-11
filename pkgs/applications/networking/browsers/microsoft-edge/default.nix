{
  beta = import ./browser.nix {
    channel = "beta";
    version = "124.0.2478.67";
    revision = "1";
    hash = "sha256-EywgM3G0Yph3dofullSVZpXSvT2MHc4uPyGAoaXCgN8=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "125.0.2535.6";
    revision = "1";
    hash = "sha256-iD/e7AuPG0uNZY20wFQRbvAaKmaUw2RKeRJADU1MFRI=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "124.0.2478.67";
    revision = "1";
    hash = "sha256-PRL2aiebCoK0eGJWlvI+Gsk14FltV+GaQdojLuDFimU=";
  };
}
