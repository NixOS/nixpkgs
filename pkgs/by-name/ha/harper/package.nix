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
  version = "2.7.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-neXBLfpqrrT7GWTEVs03AA5+ixSLIrRUuzRdXsXfS4Q=";
  };

  cargoHash = "sha256-dp2VPKoOVmB1rD8ET5I3zAvGKZQMmw5wdWUwr3TMk+k=";

  cargoBuildFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  cargoTestFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  passthru = {
    tests = vscode-extensions.elijah-potter.harper;
    updateScript = nix-update-script { };
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
