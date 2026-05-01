{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ev-cmd";
  version = "1.0.1";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  src = fetchFromGitHub {
    owner = "danhab99";
    repo = "ev-cmd";
    tag = "${finalAttrs.version}";
    hash = "sha256-zGawHgJx/KPbM8T5jKXAPOvhbNwzMa8acCgNaIyg1Fs=";
  };

  cargoHash = "sha256-YTVw1w+pr+G7c+1edKtul72n8q71R2+kheHIV/KTybg=";

  meta = {
    description = "Simple keyboard based command runner";
    homepage = "https://github.com/danhab99/ev-cmd";
    changelog = "https://github.com/danhab99/ev-cmd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danhab99 ];
    mainProgram = "ev-cmd";
  };
})
