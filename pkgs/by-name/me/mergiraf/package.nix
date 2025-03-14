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
  version = "0.6.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "refs/tags/v${version}";
    hash = "sha256-1GiXGwNgJvA3uftLu2nWa2/Tp/koCybr2r/MXkJR6hk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+qnaxWkh0ZOi4gKSLHxSeFDMmJsUM9PHL7jaH3+6OhY=";

  nativeCheckInputs = [
    git
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://mergiraf.org/";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      zimbatm
      genga898
    ];
    mainProgram = "mergiraf";
  };
}
