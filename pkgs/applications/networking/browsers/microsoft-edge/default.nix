{
  beta = import ./browser.nix {
    channel = "beta";
    version = "124.0.2478.19";
    revision = "1";
    hash = "sha256-+CanF7AadFQJj3t8OnZyoxPG2f2KO2e+EVBofKG3slg=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "125.0.2492.1";
    revision = "1";
    hash = "sha256-S6DfXJfxR8FsHyRtCcvUialaVYP/1rPivjRVSm9XAtg=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "123.0.2420.81";
    revision = "1";
    hash = "sha256-3c4DHs0p2YDW17nzCXB+O6PR9wTMb9h98EvN11imvsM=";
  };
}
