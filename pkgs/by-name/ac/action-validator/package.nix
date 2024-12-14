{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "action-validator";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    rev = "v${version}";
    hash = "sha256-lJHGx/GFddIwVVXRj75Z/l5CH/yuw/uIhr02Qkjruww=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-mBY+J6JcIhV++tO6Dhw5JvYLSwoYZR3lB3l0KTjkcQM=";

  meta = with lib; {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with maintainers; [ thiagokokada ];
  };
}
