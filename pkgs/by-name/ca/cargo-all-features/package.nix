{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pD0lyI2zSOeEDk1Lch4Qf5mo8Z8Peiy2XF5iQ62vsaI=";
  };

  postPatch = ''
    substituteInPlace tests/settings.rs \
      --replace-fail 'cmd.env("RUSTFLAGS", "-Cinstrument-coverage");' '''
  '';

  cargoHash = "sha256-EKDeBib52Os1X3sgM9CtrNkl20l1Wn/cMBIBM1/KY5A=";

  meta = with lib; {
    description = "Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
