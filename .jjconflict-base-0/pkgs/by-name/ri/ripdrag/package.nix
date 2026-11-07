{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ripdrag";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zpfT/nMy+sndDg3RWjbJ3ZxyBWoCst+cA+GKUBCTd1g=";
  };

  cargoHash = "sha256-JitYn3SDCG/1UG2FZyGbhvXqTUJ/g977IBK84pgDcNw=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ gtk4 ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "ripdrag";
  };
})
