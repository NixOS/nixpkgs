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
  version = "0.5.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "refs/tags/v${version}";
    hash = "sha256-CiZG0O5F2sidInSFUtB1q5GSfTIjX9xUr52y0TZ5tDs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-32DXHg0xVfUID8/jFNm3gowjOwCOsXH9sXDGM5yK7sA=";

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
