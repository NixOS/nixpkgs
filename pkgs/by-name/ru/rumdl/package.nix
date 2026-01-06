{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenvNoCC,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumdl";
  version = "0.0.211";

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "rumdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EW/JQlzve46eKCuDqXmvdeU1X3khtuk/WiUD5XoD+N4=";
  };

  cargoHash = "sha256-dres1qO4YqmGwnjFDp6alh5+QTQa4liDBv6iMXFBlck=";

  cargoBuildFlags = [
    "--bin=rumdl"
  ];

  # Non-specific tests often fail on Darwin (especially aarch64-darwin),
  # on both Hydra and GitHub-hosted runners, even with __darwinAllowLocalNetworking enabled.
  doCheck = !stdenvNoCC.hostPlatform.isDarwin;

  nativeCheckInputs = [
    gitMinimal
  ];

  useNextest = true;

  cargoTestFlags = [
    "--profile ci"
  ];

  checkFlags = [
    # Skip Windows tests
    "--skip comprehensive_windows_tests"
    "--skip windows_vscode_tests"
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
