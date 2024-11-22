{
  stdenv,
  lib,
  fetchFromGitea,
  rustPlatform,

  # native check inputs
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "mergiraf";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "refs/tags/v${version}";
    hash = "sha256-yBLSN5+rPPoxA6Bn1O2NNGNo9cDfowZdaOtVvvUmNAM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-xml-0.7.0" = "sha256-RTWvOUAs3Uql9DKsP1jf9FZZHaZORE40GXd+6g6RQZw=";
    };
  };

  nativeCheckInputs = [
    git
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://mergiraf.org/";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      zimbatm
      genga898
    ];
    mainProgram = "mergiraf";
  };
}
