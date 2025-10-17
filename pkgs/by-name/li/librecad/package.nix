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
  version = "2.2.1.2";

  src = fetchFromGitHub {
    owner = "LibreCAD";
    repo = "LibreCAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/0prti7aFIzoHXyd6NsiKx4ugW/vRXURAHBrAqyp84=";
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

    substituteInPlace librecad/src/src.pro \
      --replace-warn '$$[QT_INSTALL_BINS]' '${lib.getDev qt5.qttools}/bin'
    substituteInPlace librecad/src/muparser.pri \
      --replace-warn "macx|" ""
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv LibreCAD.app $out/Applications
      ln -s $out/Applications/LibreCAD.app/Contents/MacOS/LibreCAD $out/bin/librecad
      # Prevent wrapping, otherwise plugins will not be loaded
      chmod -x $out/Applications/LibreCAD.app/Contents/Resources/plugins/*.dylib
    ''}

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -Dm555 -t $out/bin                unix/{librecad,ttf2lff}
      install -Dm444 -t $out/share/applications desktop/librecad.desktop
      install -Dm644 -t $out/share/pixmaps      librecad/res/main/librecad.png
      install -Dm444 desktop/librecad.sharedmimeinfo $out/share/mime/packages/librecad.xml
      install -Dm444 desktop/graphics_icons_and_splash/Icon\ LibreCAD/Icon_Librecad.svg \
        $out/share/icons/hicolor/scalable/apps/librecad.svg

      installManPage desktop/librecad.?

      cp -R unix/resources $out/share/librecad
    ''}

    runHook postInstall
  '';

  meta = {
    description = "2D CAD package based on Qt";
    homepage = "https://librecad.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "librecad";
  };
})
