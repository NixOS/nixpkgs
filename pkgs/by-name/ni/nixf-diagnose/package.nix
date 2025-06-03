{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixf-diagnose";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "inclyc";
    repo = "nixf-diagnose";
    tag = finalAttrs.version;
    hash = "sha256-gkeU3EwAl9810eRRp5/ddf1h0qpV6FrBBdntNBpBtsM=";
  };

  env.NIXF_TIDY_PATH = lib.getExe nixf;

  useFetchCargoVendor = true;
  cargoHash = "sha256-nrr2/lTWPyH7MsG2hSMJjbFCpHsKWINEP8jwSYPhocg=";

  meta = {
    description = "CLI wrapper for nixf-tidy with fancy diagnostic output";
    mainProgram = "nixf-diagnose";
    homepage = "https://github.com/inclyc/nixf-diagnose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ inclyc ];
  };
})
