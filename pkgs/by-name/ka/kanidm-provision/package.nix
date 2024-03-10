{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "kanidm-provision";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    rev = "v${version}";
    hash = "sha256-T6kiBUdOMHCWRUF/vepoPrvaULDQrUGYsd/3I11HCLY=";
  };

  cargoHash = "sha256-nHp3C6szJxOogH/kETIqcQQNhFqBCO0P66j7n3UHuwo=";

  meta = with lib; {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [oddlama];
    mainProgram = "kanidm-provision";
  };
}
