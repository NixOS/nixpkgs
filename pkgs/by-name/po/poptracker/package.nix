{ lib
, stdenv
, fetchFromGitHub
, util-linux
, SDL2
, SDL2_ttf
, SDL2_image
, openssl
, which
, libsForQt5
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poptracker";
  version = "0.25.7";

  src = fetchFromGitHub {
    owner = "black-sliver";
    repo = "PopTracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wP2d8cWNg80KUyw1xPQMriNRg3UyXgKaSoJ17U5vqCE=";
    fetchSubmodules = true;
  };

  patches = [ ./assets-path.diff ];

  postPatch = ''
     substituteInPlace src/poptracker.cpp --replace "@assets@" "$out/share/$pname/"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    util-linux
    makeWrapper
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    openssl
  ];

  buildFlags = [
    "native"
    "CONF=RELEASE"
    "VERSION=v${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin build/linux-x86_64/poptracker
    install -m444 -Dt $out/share/${finalAttrs.pname} assets/*
    wrapProgram $out/bin/poptracker --prefix PATH : ${lib.makeBinPath [ which libsForQt5.kdialog ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Scriptable tracker for randomized games";
    longDescription = ''
      Universal, scriptable randomizer tracking solution that is open source. Supports auto-tracking.

      PopTracker packs should be placed in `~/PopTracker/packs` or `./packs`.
    '';
    homepage = "https://github.com/black-sliver/PopTracker";
    changelog = "https://github.com/black-sliver/PopTracker/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ freyacodes ];
    mainProgram = "poptracker";
    platforms = [ "x86_64-linux" ];
  };
})
