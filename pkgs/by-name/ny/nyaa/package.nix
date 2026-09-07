{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nyaa";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Beastwick18";
    repo = "nyaa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WxOGtNMqQoEgztLaitwpE4MusGaLuKMmqi9L4prfOBY=";
  };

  cargoHash = "sha256-oCe0Yn0DuwF7rG+MGBGQ0Fsgt3c4Wju7uFkp3+IiP0I=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Beastwick18/nyaa/releases/tag/v${finalAttrs.version}";
    description = "Tui tool for browsing and downloading torrents";
    homepage = "https://github.com/Beastwick18/nyaa";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nyaa";
    maintainers = with lib.maintainers; [ redyf ];
    platforms = lib.platforms.unix;
  };
})
