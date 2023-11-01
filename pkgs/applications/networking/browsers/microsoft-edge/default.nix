{
  stable = import ./browser.nix {
    channel = "stable";
    version = "118.0.2088.76";
    revision = "1";
    sha256 = "sha256-cd8W/0UZi+NhPSILR8e8aOLxy6ra+0DVwRowo2jG8DA=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "119.0.2151.32";
    revision = "1";
    sha256 = "sha256-tsDFUKZDiusr/fGO5NMRqzTDIF+MTgC/1gJu95wXwAw=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "120.0.2172.1";
    revision = "1";
    sha256 = "sha256-EvTS0AO3/A8Ut9H36mMOnS9PRR062WAoas9/Pd90NBM=";
  };
}
