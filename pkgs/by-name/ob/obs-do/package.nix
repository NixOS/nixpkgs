{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-do";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mYxOjUVjICVqFFw1SX7TsVkbnvhilVmj+8LSZTNBbFE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OgSEJOY0m3wfccPfhIon11xyC/ywYaTBjGYLkRr/y/Q=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI for common OBS operations while streaming using WebSocket";
    homepage = "https://github.com/jonhoo/obs-do";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "obs-do";
  };
})
