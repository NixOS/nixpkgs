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

  cargoHash = "sha256-tQ3uVsy5Dw4c4CbSeASv1TWkqxVYjl/Cjkr00OQEo9c=";

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
