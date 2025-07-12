{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bloxx12";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CCHWxQjronLhyt5MB2bb2vgmOgvjYaIr2HNbmUmT+gw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/3uL++0IEI2Yw3xrkS0UQmDZX3p0tQCqMyuUCcol1A0=";

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
