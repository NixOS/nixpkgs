{
  stable = import ./browser.nix {
    channel = "stable";
    version = "118.0.2088.46";
    revision = "1";
    sha256 = "sha256-/3lo/y/LhAmGqiOhZgDoJVS+c2631NB/Z/lBNFunU30=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "118.0.2088.46";
    revision = "1";
    sha256 = "sha256-u0w7COYoAgcpqVEsB0t27iMD2AGVYFCJyE72uWKIY70=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "119.0.2151.2";
    revision = "1";
    sha256 = "sha256-42wbnA9i1FdBq14Y+xxstAe9ciWDzEBVMULCSURQzj0=";
  };
}
