{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bloxx12";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hsTw0MyxYD4UtUEeXgNRjmp1yla9Renl6xD19XQ5/LY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9uGtkWBShoge5tyeIdgJhthaBDF2nzCUbeY8HcaLWYc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/bloxx12/dix";
    description = "Blazingly fast tool to diff Nix related things";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      bloxx12
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
