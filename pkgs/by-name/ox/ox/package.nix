{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ox";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = "ox";
    tag = finalAttrs.version;
    hash = "sha256-h4oC+TRLPKgXid4YIn2TdTxgEBvbBDy66jfbyA5ia4o=";
  };

  cargoHash = "sha256-Vf5Y/rXykaYkrnTjVMShnGYikDIu2b1l2oDOiB0O95I=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      moni
    ];
    mainProgram = "ox";
  };
})
