{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "md-tui";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y6AkkZc9d+I4vVeyGnkShHBAAM70shKCWaZpJxn0a0k=";
  };

  cargoHash = "sha256-3iD5xp+v9xz5Ru/OGR8SBMmuAioS7usjtfbCgWaizzs=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown renderer in the terminal";
    homepage = "https://github.com/henriklovhaug/md-tui";
    changelog = "https://github.com/henriklovhaug/md-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      anas
    ];
    platforms = lib.platforms.all;
    mainProgram = "mdt";
  };
})
