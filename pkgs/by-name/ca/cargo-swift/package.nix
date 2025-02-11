{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-T8cIZJwnA3bFMIEezMrh5LRXV1SRCAVLanQm7rmc0sU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Zl5y2pHQIcLU5EDtmxsAv+/0n4DZ/qXwN4Prmm8Nd34=";

  meta = with lib; {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ elliot ];
  };
}
