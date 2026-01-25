{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "auto-sync";
  version = "1.1.2-unstable-2023-11-20";
  src = fetchFromGitHub {
    owner = "Robin-Haupt-1";
    repo = "Auto-Sync-Anki-Addon";
    rev = "30d09d8b48c97cd66ef68ae73815b1cb29bcbc55";
    hash = "sha256-dBEWyHLN6lwWEsrKULYnACqexjVsvZUpXWOLJy9vwkA=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Auto-sync your collection while Anki is idle
    '';
    homepage = "https://github.com/Robin-Haupt-1/Auto-Sync-Anki-Addon";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dastarruer ];
  };
})
