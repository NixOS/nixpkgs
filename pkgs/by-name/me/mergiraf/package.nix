{
  lib,
  fetchFromGitea,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "mergiraf";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yBLSN5+rPPoxA6Bn1O2NNGNo9cDfowZdaOtVvvUmNAM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-xml-0.7.0" = "sha256-RTWvOUAs3Uql9DKsP1jf9FZZHaZORE40GXd+6g6RQZw=";
    };
  };

  checkFlags = [
    # Test panics since git command fails to execute
    "--skip=test_solve_command::case_1"
    "--skip=test_solve_command::case_2"
  ];

  nativeInputChecks = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://codeberg.org/mergiraf/mergiraf";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "mergiraf";
  };
}
