{
  stdenv,
  lib,
  fetchFromSourcehut,
  gitUpdater,
  hareHook,
  hareThirdParty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bonsai";
  version = "1.5.1";

  src = fetchFromSourcehut {
    owner = "~stacyharper";
    repo = "bonsai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cAlTppDNXXZaL5bG+h4jANfFg2OBd0WqEmDBmY5IvZ8=";
  };

  nativeBuildInputs = [
    hareHook
    hareThirdParty.hare-ev
    hareThirdParty.hare-json
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Finite State Machine structured as a tree";
    homepage = "https://git.sr.ht/~stacyharper/bonsai";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
    mainProgram = "bonsaictl";
  };
})
