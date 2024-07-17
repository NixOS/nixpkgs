{
  stdenv,
  lib,
  fetchFromSourcehut,
  gitUpdater,
  hare,
  hareThirdParty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bonsai";
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~stacyharper";
    repo = "bonsai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wsr76OQOIqRPCx/8GK9NovxxPZ3dEP8pSo8wgMK1Hfo=";
  };

  nativeBuildInputs = [
    hare
    hareThirdParty.hare-ev
    hareThirdParty.hare-json
  ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "HARECACHE=.harecache"
    "HAREFLAGS=-qa${stdenv.hostPlatform.uname.processor}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'hare build' 'hare build $(HAREFLAGS)' \
      --replace 'hare test' 'hare test $(HAREFLAGS)'
  '';

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
