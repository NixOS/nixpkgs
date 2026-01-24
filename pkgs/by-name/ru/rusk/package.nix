{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusk";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tagirov";
    repo = "rusk";
    tag = finalAttrs.version;
    hash = "sha256-pxaOOK/ZwHsP52heNuCcdC7nghp6tdwbNTbAnGdQVEU=";
  };

  cargoHash = "sha256-Qm+8oySDAjWcvhQivkvOjDeHMHOJ1hhcjKDt/H9kGlM=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal terminal task manager";
    homepage = "https://github.com/tagirov/rusk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rusk";
  };
})
