{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shuck";
  version = "0.2.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ewhauser";
    repo = "shuck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KJ34JZJsPaEBEY1BDEDCu13PcmVLVoK1Dqqij7iN1dQ=";
  };

  cargoHash = "sha256-yXIAwjUAcZepaAkurISyAxVOB1psLImK2nTAxc4eSuw=";

  cargoBuildFlags = [
    "--package"
    "shuck-cli"
  ];

  cargoTestFlags = [
    # Skip flaky tests
    "--lib"

    "--package"
    "shuck-cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Shell script linter, formatter, and language server";
    downloadPage = "https://github.com/ewhauser/shuck";
    homepage = "https://ewhauser.github.io/shuck/";
    changelog = "https://github.com/ewhauser/shuck/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shuck";
    platforms = with lib.platforms; unix ++ windows;
  };
})
