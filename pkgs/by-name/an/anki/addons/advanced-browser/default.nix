{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "advanced-browser";
  version = "4.5";
  src = fetchFromGitHub {
    owner = "AnKing-VIP";
    repo = "advanced-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oVL+Y96/d+uD8s6yjz6L7zWV2G6PgP7ZfIiEAAZR2T4=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Adds more sorting options to the browser";
    longDescription = ''
      A general overview of the functionality can be found [here](https://ankiweb.net/shared/info/874215009).
      The options to configure this add-on can be found [here](https://github.com/AnKing-VIP/advanced-browser/blob/v${finalAttrs.version}/advancedbrowser/config.md).
    '';
    homepage = "https://ankiweb.net/shared/info/874215009";
    downloadPage = "https://github.com/AnKing-VIP/advanced-browser";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ n0pl4c3 ];
  };
})
