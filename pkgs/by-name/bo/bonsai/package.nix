{ stdenv
, lib
, fetchFromSourcehut
, gitUpdater
, hare
, hareThirdParty
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bonsai";
  version = "1.0.2";

  src = fetchFromSourcehut {
    owner = "~stacyharper";
    repo = "bonsai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yosf07KUOQv4O5111tLGgI270g0KVGwzdTPtPOsTcP8=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Finite State Machine structured as a tree";
    homepage = "https://git.sr.ht/~stacyharper/bonsai";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    mainProgram = "bonsaictl";
  };
})
