{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "auto-sync";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "Robin-Haupt-1";
    repo = "Auto-Sync-Anki-Addon";
    tag = finalAttrs.version;
    hash = "sha256-BCD2rJgoeSCenJByMtB6xZxWqQtY5vMGG6dd/AiQnRM=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Auto sync your Anki cards while the app is idle.
    '';
    homepage = "https://github.com/Robin-Haupt-1/Auto-Sync-Anki-Addon";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dastarruer ];
  };
})
