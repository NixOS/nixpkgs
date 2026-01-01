{
  lib,
  anki-utils,
  fetchFromSourcehut,
<<<<<<< HEAD
  gitUpdater,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-connect";
  version = "25.11.9.0";
=======
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-connect";
  version = "25.9.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromSourcehut {
    owner = "~foosoft";
    repo = "anki-connect";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-cnAH4qIuxSJIM7vmSDU+eppnRi6Out9oSWHBHKCGLZI=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  passthru.updateScript = gitUpdater { };
=======
    hash = "sha256-ZPjGqyxTyLg5DtOUPJWCBC/IMfDVxtWt86VeFrsE41k=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
