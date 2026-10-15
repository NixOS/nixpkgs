{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1kL3g28nxf6F9izJES4WSW8pdu/rqRhMo6WzOKo9zEI=";
  };

  cargoHash = "sha256-yolA1uoxhpExOF/hzN9EZeQuexoMaBkAza+5qw3lA04=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash file or directory recursively";
    homepage = "https://github.com/gregl83/paq";
    changelog = "https://github.com/gregl83/paq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gregl83
      lafrenierejm
    ];
    mainProgram = "paq";
  };
})
