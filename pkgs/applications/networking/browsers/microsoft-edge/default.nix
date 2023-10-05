{
  stable = import ./browser.nix {
    channel = "stable";
    version = "117.0.2045.55";
    revision = "1";
    sha256 = "sha256-9z+SxiM1ODTq3kalMeeV+W5QZ2VY1OB+KpiXgSxNvEM=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "118.0.2088.24";
    revision = "1";
    sha256 = "sha256-CrsFTGvD8WE4CcZ3Fw97f5yGzWYiFNuMfwC6WM5nATQ=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "119.0.2132.0";
    revision = "1";
    sha256 = "sha256-sBR1/N8k+4oaGcb2/ZLAeMGCuSuGOcSxvP3ofGfFYDU=";
  };
}
