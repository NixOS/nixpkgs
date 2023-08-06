{
  stable = import ./browser.nix {
    channel = "stable";
    version = "114.0.1823.79";
    revision = "1";
    sha256 = "sha256-FyEsIGwGDzX22scKd8L67uw5ipqN1e9CrC+qACRBZRg=";
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
