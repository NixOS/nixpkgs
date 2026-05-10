{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9AA2uln9cnMzFvPbxiD05sfdAZKO7xzoJSfQbeRNE9Y=";
  };

  cargoHash = "sha256-P90qKrV4YK1ATwclbJ8wX+rcCdE1QetNNL96/IXeIMA=";

  cargoBuildFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  cargoTestFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  passthru.updateScript = nix-update-script { };

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
