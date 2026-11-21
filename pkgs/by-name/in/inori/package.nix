{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inori";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YsZy8eClhu8uKBTQY7K1E4dKxOQ9icPexxGPlwWTEPU=";
  };

  cargoHash = "sha256-aiSSDThNRZgSE5B36B+LsIbQdA/hoY86vTXkkZuG16I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [
      stephen-huan
      esrh
    ];
  };
})
