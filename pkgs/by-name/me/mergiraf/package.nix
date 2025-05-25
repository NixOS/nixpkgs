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
  version = "0.8.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "refs/tags/v${version}";
    hash = "sha256-HtIrl9q64JLV/ufJ2g9OrQDDOkcwvyn4+l6/dUqwXkw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xe+JbXKOfxj0XSUM3zW0cYkWo22nyTOp+mOudv3UbE4=";

  nativeCheckInputs = [
    git
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

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
