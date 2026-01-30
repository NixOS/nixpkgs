{
  lib,
  fetchFromGitHub,
  rustPlatform,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumdl";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "rumdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8K+jZL/yo7ur5WD+5+L+ZHhFkhYo83brgD6Gg1Xo6js=";
  };

  cargoHash = "sha256-dpHV5+DJLsjwvLkxtXOS7CYUNKXW57o0O541pO8vN5U=";

  cargoBuildFlags = [
    "--bin=rumdl"
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  useNextest = true;

  cargoTestFlags = [
    # Prefer the "smoke" profile over "ci" to exclude flaky tests: https://github.com/rvben/rumdl/pull/341
    "--profile smoke"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown linter and formatter";
    longDescription = ''
      rumdl is a high-performance Markdown linter and formatter
      that helps ensure consistency and best practices in your Markdown files.
    '';
    homepage = "https://github.com/rvben/rumdl";
    changelog = "https://github.com/rvben/rumdl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
      hasnep
    ];
    mainProgram = "rumdl";
    platforms = with lib.platforms; unix ++ windows;
  };
})
