{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8CSlxkF60OH1uJz7kCPhmHrSXo9C2mlkw0DxO7gUKVk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Z0+c2+87rhkiRUVr5udS1iJjMoEUlxsPR4KLjqGmlHs=";

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/Enter-tainer/typstyle/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
