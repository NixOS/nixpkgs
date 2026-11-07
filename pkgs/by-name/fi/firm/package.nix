{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firm";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "42futures";
    repo = "firm";
    tag = finalAttrs.version;
    hash = "sha256-kTmyAuz2Q6uvsDeCNbDcdq+D+JJQuH0S/oy0mUzV+Qs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-ajR2NbNQy9ruTbDxSG9c8Y05Ck11zsbfepckiFyRKbc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text-based work management system for technologists";
    homepage = "https://firm.42futures.com/";
    changelog = "https://github.com/42futures/firm/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "firm";
  };
})
