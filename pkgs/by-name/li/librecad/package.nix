{
  lib,
  stdenv,
  boost,
  fetchFromGitHub,
  installShellFiles,
  muparser,
  pkg-config,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librecad";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "LibreCAD";
    repo = "LibreCAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBn4lduzaKWEWzeTNjC9TpioSouVj+jVl32PLjc8FBc=";
  };

  buildInputs = [
    boost
    muparser
    qt5.qtbase
    qt5.qtsvg
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qt5.qmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "BOOST_DIR=${boost.dev}"
  ];

  postPatch = ''
    substituteInPlace librecad/src/main/qc_applicationwindow.cpp \
      --replace-warn __DATE__ 0
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                unix/{librecad,ttf2lff}
    install -Dm444 -t $out/share/applications desktop/librecad.desktop
    install -Dm644 -t $out/share/pixmaps      librecad/res/main/librecad.png
    install -Dm444 desktop/librecad.sharedmimeinfo $out/share/mime/packages/librecad.xml
    install -Dm444 desktop/graphics_icons_and_splash/Icon\ LibreCAD/Icon_Librecad.svg \
      $out/share/icons/hicolor/scalable/apps/librecad.svg

    installManPage desktop/librecad.?

    cp -R unix/resources $out/share/librecad

    runHook postInstall
  '';

  meta = {
    description = "2D CAD package based on Qt";
    homepage = "https://librecad.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
  };
})
