{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-do";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lx2938VCqNsyKSAUie8MMOSsFYfvvEZ4dCHJ03y6+TY=";
  };

  cargoHash = "sha256-U/E+gWzJgpF2iZN0jYgAXC58AH64HI8AvvTfD9YaerI=";

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
