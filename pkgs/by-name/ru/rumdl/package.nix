{
  lib,
  fetchFromGitHub,
  rustPlatform,
<<<<<<< HEAD
  stdenvNoCC,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumdl";
<<<<<<< HEAD
  version = "0.0.203";
=======
  version = "0.0.181";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "rumdl";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-co+DlgUUxHR77wXCapzCSScImL3NPzFXM5d1YFPZxgk=";
  };

  cargoHash = "sha256-gZw1DsKsIh4xeovJYj3lgQ+2cqqy8GfkEhtDfgq7LWs=";
=======
    hash = "sha256-qwsZ4S0F9JEpVP05RbvUQT8mBemtJQwJ6DRMp+r2TM0=";
  };

  cargoHash = "sha256-DwCzpyoJcnD/j3umEJGMaMlt0WgPtK3HaztDieuWo90=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoBuildFlags = [
    "--bin=rumdl"
  ];

<<<<<<< HEAD
  # Non-specific tests often fail on Darwin (especially aarch64-darwin),
  # on both Hydra and GitHub-hosted runners, even with __darwinAllowLocalNetworking enabled.
  doCheck = !stdenvNoCC.hostPlatform.isDarwin;
=======
  __darwinAllowLocalNetworking = true; # required for LSP tests
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
