{ lib
, boost
, fetchFromGitHub
, installShellFiles
, mkDerivation
, muparser
, pkg-config
, qmake
, qtbase
, qtsvg
, qttools
, runtimeShell
}:

mkDerivation rec {
  pname = "librecad";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "LibreCAD";
    repo = "LibreCAD";
    rev = version;
    sha256 = "sha256-horKTegmvcMg4m5NbZ4nzy4J6Ac/6+E5OkiZl0v6TBc=";
  };

  buildInputs = [
    boost
    muparser
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qmake
    qttools
  ];

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "BOOST_DIR=${boost.dev}"
  ];

  postPatch = ''
    substituteInPlace scripts/postprocess-unix.sh \
      --replace /bin/sh ${runtimeShell}

    substituteInPlace librecad/src/main/qc_applicationwindow.cpp \
      --replace __DATE__ 0
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

  meta = with lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://librecad.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kiwi viric ];
    platforms = platforms.linux;
  };
}
