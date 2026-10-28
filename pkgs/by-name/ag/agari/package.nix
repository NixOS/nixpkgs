{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agari";
  version = "0.27.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agari-industries";
    repo = "agari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rsnGwlkHhBDUlGWGDFGyl++pfSYknygcbLZlRcRjYM0=";
  };

  cargoHash = "sha256-TGsKgTbCkJDme9ZQHaQiMQFR3kVf4kSccQ4FaxjYX2I=";

  nativeBuildInputs = [ python3 ];

  cargoBuildFlags = [
    "--package=agari"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Comprehensive Riichi Mahjong scoring engine";
    homepage = "https://github.com/agari-industries/agari";
    changelog = "https://github.com/agari-industries/agari/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "agari";
  };
})
