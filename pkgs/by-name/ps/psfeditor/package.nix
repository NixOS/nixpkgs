{
  lib,
  stdenv,
  qt5,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "psfeditor";
  version = "0-unstable-2025-04-07";

  src = fetchFromGitHub {
    owner = "ideras";
    repo = "PSFEditor";
    rev = "1942494a110b100e7609c10e0e3c2a7258cd20d4";
    hash = "sha256-+A0XHwQ0yjTaj4ua0Y6OnsIYkaRD3dj/NonJnusykao=";
  };

  buildInputs = [
    qt5.qtbase
  ];

  nativeBuildInputs = with qt5; [
    qmake
    wrapQtAppsHook
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin
    install ./PSFEditor $out/bin/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "PC Screen font editor";
    homepage = "https://github.com/ideras/PSFEditor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "PSFEditor";
    platforms = lib.platforms.linux;
  };
}
