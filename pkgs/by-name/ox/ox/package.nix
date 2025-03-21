{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = "ox";
    tag = version;
    hash = "sha256-h4oC+TRLPKgXid4YIn2TdTxgEBvbBDy66jfbyA5ia4o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vf5Y/rXykaYkrnTjVMShnGYikDIu2b1l2oDOiB0O95I=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      moni
      kachick
    ];
    mainProgram = "ox";
  };
}
