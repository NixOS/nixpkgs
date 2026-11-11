{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macmon";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/nZTmnM2OT/iDB+vmVd5SptCOCUUF4yn2/Yu45At/0E=";
  };

  cargoHash = "sha256-hk3PCNLfUrOT+wT8ZLWd2KZWTYK7Kv8+2a1jBIO7Ti8=";

  checkFlags = [
    # Reads launchd through /bin/ps, which is unavailable in the sandbox
    "--skip=procs::tests::samples_current_process"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sudoless performance monitoring for Apple Silicon processors";
    homepage = "https://github.com/vladkens/macmon";
    changelog = "https://github.com/vladkens/macmon/releases/tag/${finalAttrs.src.tag}";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
    mainProgram = "macmon";
  };
})
