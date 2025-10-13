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
  version = "1.2.1";

  src = fetchFromSourcehut {
    owner = "~stacyharper";
    repo = "bonsai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WAne0628lELQanUv2lg8Y9QEikZVAT7Xtkndhs8Ozjw=";
  };

  nativeBuildInputs = [
    hareHook
    hareThirdParty.hare-ev
    hareThirdParty.hare-json
  ];

  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Finite State Machine structured as a tree";
    homepage = "https://git.sr.ht/~stacyharper/bonsai";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    mainProgram = "bonsaictl";
  };
})
