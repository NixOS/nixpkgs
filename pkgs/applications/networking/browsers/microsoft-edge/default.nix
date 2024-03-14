{
  beta = import ./browser.nix {
    channel = "beta";
    version = "123.0.2420.32";
    revision = "1";
    hash = "sha256-ItKwlXaHHupTIXrwc4IXaFvldhFGZc4L8aJnxM1XLkM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "124.0.2438.2";
    revision = "1";
    hash = "sha256-QMcq1lgtO50u2DoTdugJvkOcnIkppmeg/UCQ1oc5TZs=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "122.0.2365.80";
    revision = "1";
    hash = "sha256-fBu5ANA23Oicr3otQiqNznkUT0M9NcrDs6oNW/JuBtk=";
  };
}
