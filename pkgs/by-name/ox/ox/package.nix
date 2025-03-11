{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    tag = version;
    hash = "sha256-kTCdq3C0OUQS3tQRwEJ0+MTHZ8j2nnUARjdbmfH6ed4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1d5gGqEn6kBCXqAnwHAe7rnvaGG2wVODrxeQt+k6iJs=";

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
