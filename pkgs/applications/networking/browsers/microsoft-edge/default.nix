{
  stable = import ./browser.nix {
    channel = "stable";
    version = "115.0.1901.188";
    revision = "1";
    sha256 = "sha256-0xf2d2wxc2hjxz070nkrbgsszylwhck6x655ginjmh0qm76kf4wr";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "115.0.1901.165";
    revision = "1";
    sha256 = "sha256-2DUWkGItissLGtJAMDKHNjMDPhsYNKaQVJ30+tMlkow=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "116.0.1938.10";
    revision = "1";
    sha256 = "sha256-NQXaLmX8AtLEWPkkzAA90XfmFflwulxVRHtIJ+nxCk4=";
  };
}
