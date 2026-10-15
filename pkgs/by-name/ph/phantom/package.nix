{
  stdenv,
  fetchFromCodeberg,
  qt6,
  cmark-gfm,
  cmake,
  pkg-config,
  lib,
}:

stdenv.mkDerivation {
  pname = "phantom";
  version = "0.0.0-unstable-2025-12-22";

  src = fetchFromCodeberg {
    owner = "ItsZariep";
    repo = "Phantom";
    rev = "7bba1e0a2d9b33d881fb999bb543324d14355505";
    hash = "sha256-KjQX6Hxp4hcRJWRF/CDxZGQtzQqozGWxxHn0VpOzR0U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    cmark-gfm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/app
    cp phantom-qt $out/bin
    cp ../src/phantom-qt.desktop $out/share/applications
    cp ../src/phantom.svg $out/share/icons/hicolor/scalable/app

    runHook postInstall
  '';

  meta = {
    description = "Markdown editor with support for multi-tab";
    homepage = "https://codeberg.org/ItsZariep/Phantom";
    license = lib.licenses.gpl3Only;
    mainProgram = "phantom-qt";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ reylak ];
  };
}
