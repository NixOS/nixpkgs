{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macmon";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Mzt4Lmo5VW4K7q/C1+XX7gueq8kN1V11tHmgF18jCk=";
  };

  cargoHash = "sha256-SlSMymT5c4OaXXcYMEfOnxn3GelEOznnFTi6ihTLqC4=";

  checkFlags = [
    # Read launchd through /bin/ps, which is unavailable in the sandbox
    "--skip=procs::tests::ps_rows_are_reused_until_the_next_run"
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
