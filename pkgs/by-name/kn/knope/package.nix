{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "knope";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "knope-dev";
    repo = "knope";
    tag = "knope/v${finalAttrs.version}";
    hash = "sha256-8vR1kNx1UFwROCRm1LtrTcBmiZoKZ9sXP5MdAvYWLRI=";
  };

  cargoHash = "sha256-69x6tErSmH3QcQGIu9jc77JlWkm+Z+2Yae5CjzsfiQk=";

  nativeBuildInputs = [
    pkg-config
  ];

  # Integration tests require git and network access
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^knope/v(.*)$"
    ];
  };

  meta = {
    description = "A command line tool for automating common development tasks";
    homepage = "https://knope.tech";
    changelog = "https://github.com/knope-dev/knope/blob/knope/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ifiokjr ];
    mainProgram = "knope";
  };
})
