{
  lib,
  anki-utils,
  fetchFromSourcehut,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-connect";
  version = "25.9.6.0";
  src = fetchFromSourcehut {
    owner = "~foosoft";
    repo = "anki-connect";
    tag = finalAttrs.version;
    hash = "sha256-ZPjGqyxTyLg5DtOUPJWCBC/IMfDVxtWt86VeFrsE41k=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Enable external applications such as Yomichan to communicate
      with Anki over a simple HTTP API
    '';
    homepage = "https://git.sr.ht/~foosoft/anki-connect";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
