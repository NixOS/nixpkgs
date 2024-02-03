{ mkDerivation
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qtbase
, qtquickcontrols2
, qtwebsockets
, qtmultimedia
, gst_all_1
, wrapQtAppsHook
, makeDesktopItem
, copyDesktopItems
, libvlc
}:

mkDerivation rec {
  pname = "anilibria-winmaclinux";
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    rev = "d941607f078c72fca104ee1e7916cc0ddcc0acf5";
    sha256 = "sha256-G4KlYAjOT1UV29vcX7Q8dMTj0BX0rsJcLtK2MQag5nU=";
  };

  sourceRoot = "source/src";

  qmakeFlags = [ "PREFIX=${placeholder "out"}" "CONFIG+=unixvlc" ];

  patches = [
    ./0001-fix-installation-paths.patch
    ./0002-disable-version-check.patch
  ];

  preConfigure = ''
    substituteInPlace AniLibria.pro \
      --replace "\$\$PREFIX" '${placeholder "out"}'
  '';

  qtWrapperArgs = [
    "--prefix GST_PLUGIN_PATH : ${(with gst_all_1; lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      gst-plugins-bad
      gst-plugins-good
      gst-plugins-base
      gst-libav
      gstreamer
    ])}"
  ];

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtwebsockets
    qtmultimedia
    libvlc
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-base
    gst-libav
    gstreamer
  ]);

  desktopItems = [
    (makeDesktopItem (rec {
      name = "AniLibria";
      desktopName = name;
      icon = "anilibria";
      comment = meta.description;
      genericName = "AniLibria desktop client";
      categories = [ "Qt" "AudioVideo" "Player" ];
      keywords = [ "anime" ];
      exec = name;
      terminal = false;
    }))
  ];

  meta = with lib; {
    homepage = "https://github.com/anilibria/anilibria-winmaclinux";
    description = "AniLibria cross platform desktop client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    inherit (qtbase.meta) platforms;
    mainProgram = "AniLibria";
  };
}
