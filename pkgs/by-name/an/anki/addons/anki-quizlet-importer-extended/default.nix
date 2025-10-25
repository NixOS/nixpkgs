{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-quizlet-importer-extended";
  version = "2025.03.13";
  src = fetchFromGitHub {
    owner = "sviatoslav-lebediev";
    repo = "anki-quizlet-importer-extended";
    tag = "v${finalAttrs.version}";
    hash = "sha256-46j/CXhsrehu00P5QLuOj/08gNlFeJttslAFLgz7AJ8=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Import Quizlet Decks into Anki";
    homepage = "https://ankiweb.net/shared/info/1362209126";
    downloadPage = "https://github.com/sviatoslav-lebediev/anki-quizlet-importer-extended";
    changelog = "https://github.com/sviatoslav-lebediev/anki-quizlet-importer-extended/releases/tag/v${finalAttrs.version}";
    # No license file, but it can be assumed to be AGPL3 based on
    # https://ankiweb.net/account/terms.
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
