{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "kanidm-provision";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    rev = "v${version}";
    hash = "sha256-pgPjkj0nMb5j3EvyJTTDpfmh0WigAcMzoleF5EOqBAM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kbctfPhEF1PdVLjE62GyLDzjOnZxH/kOWUS4x2vd/+8=";

  meta = with lib; {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ oddlama ];
    mainProgram = "kanidm-provision";
  };
}
