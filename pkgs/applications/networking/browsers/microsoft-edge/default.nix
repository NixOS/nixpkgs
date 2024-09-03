{
  beta = import ./browser.nix {
    channel = "beta";
    version = "128.0.2739.42";
    revision = "1";
    hash = "sha256-VcBn2WL4rdAeEa62XT/dhC2OFLsV0Q/Sp6hqgmc/e0Y=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "129.0.2779.0";
    revision = "1";
    hash = "sha256-hlamsHTpBMGwOICga0k874q8+xuaZFMofFLG/EvB0NU=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "128.0.2739.42";
    revision = "1";
    hash = "sha256-AwdZX2Ens2+rhHLYV0efYsXYBTs2a57HyGz2k+IDMeQ=";
  };
}
