{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "action-validator";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    rev = "v${version}";
    hash = "sha256-22oYPYGnNp4K68pbNMolGcIGDYqjT/3FibO/jv3IEvg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-CVDqXuAxI1vCZV4w8DS3fOrsYFvJoI35fbe+hnSahLc=";

  meta = with lib; {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with maintainers; [ thiagokokada ];
  };
}
