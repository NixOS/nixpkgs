{ boost
, fetchFromGitHub
, installShellFiles
, mkDerivationWith
, muparser
, pkgconfig
, qmake
, qtbase
, qtsvg
, qttools
, runtimeShell
, gcc8Stdenv
}:

let
  stdenv = gcc8Stdenv;
in

# Doesn't build with gcc9
mkDerivationWith stdenv.mkDerivation rec {
  pname = "librecad";
  version = "2.2.0-rc1";

  src = fetchFromGitHub {
    owner = "LibreCAD";
    repo = "LibreCAD";
    rev = version;
    sha256 = "0kwj838hqzbw95gl4x6scli9gj3gs72hdmrrkzwq5rjxam18k3f3";
  };

  patches = [
    ./fix_qt_5_11_build.patch
  ];

  postPatch = ''
    substituteInPlace scripts/postprocess-unix.sh \
      --replace /bin/sh ${runtimeShell}

    substituteInPlace librecad/src/lib/engine/rs_system.cpp \
      --replace /usr/share $out/share

    substituteInPlace librecad/src/main/qc_applicationwindow.cpp \
      --replace __DATE__ 0
  '';

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "BOOST_DIR=${boost.dev}"
  ];

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

  buildInputs = [
    boost
    muparser
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    installShellFiles
    pkgconfig
    qmake
    qttools
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://librecad.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kiwi
      viric
    ];
    platforms = platforms.linux;
  };
}
