{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  vscode-extensions,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "2.12.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-id5+LeHKsu9sZJ3QJeZWynFyOABSbL8KjMsk7GEEt9w=";
  };

  cargoHash = "sha256-xRQah0ckm7M1mtB8+xciuD9sYx0qNpH+fTXIHvIFAt0=";

  cargoBuildFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  cargoTestFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  passthru = {
    tests.vscode = vscode-extensions.elijah-potter.harper;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "tests.vscode"
      ];
    };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
})
