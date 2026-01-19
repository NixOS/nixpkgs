{
  lib,
  anki-utils,
  fetchFromSourcehut,
  gitUpdater,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-connect";
  version = "25.11.9.0";
  src = fetchFromSourcehut {
    owner = "~foosoft";
    repo = "anki-connect";
    tag = finalAttrs.version;
    hash = "sha256-cnAH4qIuxSJIM7vmSDU+eppnRi6Out9oSWHBHKCGLZI=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  passthru.updateScript = gitUpdater { };
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
