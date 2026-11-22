{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macmon";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TWrT5NG8XW/C7rgKMw06s+Ynsvly6bM1s+ffcV19tgo=";
  };

  cargoHash = "sha256-H6CaEsLR1yXtMTU8m30P1nUSG2QidK+IaOwzn6zgRxk=";

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
