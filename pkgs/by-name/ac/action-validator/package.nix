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

  useFetchCargoVendor = true;
  cargoHash = "sha256-dy66ZkU9lIYGe9T3oR8m5cGcBQO5MF1KsLjfaHTtvlY=";

  meta = with lib; {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with maintainers; [ thiagokokada ];
  };
}
