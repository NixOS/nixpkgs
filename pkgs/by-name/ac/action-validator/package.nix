{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "action-validator";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    rev = "v${version}";
    hash = "sha256-roWmks+AgRf2ACoI7Vc/QEyqgQ0bR/XhRwLk9VaLEdY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-WUtFWuk2y/xXe39doMqANaIr0bbxmLDpT4/H2GRGH6k=";

  meta = with lib; {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with maintainers; [ thiagokokada ];
  };
}
