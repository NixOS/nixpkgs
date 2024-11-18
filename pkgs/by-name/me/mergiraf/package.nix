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

  useFetchCargoVendor = true;
  cargoHash = "sha256-FEQSZM+PFYrY+7WbZqVYqM67sEurjCR5ih49azNCyQ4=";

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
