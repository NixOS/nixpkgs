{ lib
, boost
, fetchFromGitHub
, fetchpatch
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
  version = "2.2.0-rc2";

  src = fetchFromGitHub {
    owner = "LibreCAD";
    repo = "LibreCAD";
    rev = version;
    sha256 = "sha256-RNg7ioMriH4A7V65+4mh8NhsUHs/8IbTt38nVkYilCE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/LibreCAD/LibreCAD/pull/1465/commits/4edcbe72679f95cb60979c77a348c1522a20b0f4.patch";
      sha256 = "sha256-P0G2O5sL7Ip860ByxFQ87TfV/lq06wCQnzPxADGqFPs=";
      name = "CVE-2021-45342.patch";
    })
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
    pkg-config
    qmake
    qttools
  ];

  meta = with lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://librecad.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kiwi viric ];
    platforms = platforms.linux;
  };
}
