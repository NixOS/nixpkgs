{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "faukah";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CcvPQ041W6FzGb4L9bBXgkY0iuXPzvNhcoSsXSvagzA=";
  };

  cargoHash = "sha256-8yz9X+hz3dTCBgUTmx7XjRycAljYXZ4WYg7VYQdViDA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/faukah/dix";
    description = "Blazingly fast tool to diff Nix related things";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
