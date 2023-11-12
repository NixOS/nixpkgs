{
  stable = import ./browser.nix {
    channel = "stable";
    version = "119.0.2151.44";
    revision = "1";
    sha256 = "sha256-QY9Dk4tcpuNJGVcAcaIaVXAT95K87rK7ZQo7COMDpVU=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "119.0.2151.44";
    revision = "1";
    sha256 = "sha256-aLiitzCoMvJH2xAfo9bO7lEPMqKlb++BdJkrWx61SMc=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "120.0.2186.2";
    revision = "1";
    sha256 = "sha256-L/rtOddk4bt8ffkRnq0BYcVjrSb7RmDaay85S5vixSM=";
  };
}
