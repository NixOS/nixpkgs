{ mkDerivation
, lib
, fetchFromGitHub
, qmake
, qtbase
, qtquickcontrols2
, qtwebsockets
, qtmultimedia
, gst_all_1
, wrapQtAppsHook
, makeDesktopItem
, copyDesktopItems
}:

mkDerivation rec {
  pname = "anilibria-winmaclinux";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    rev = version;
    sha256 = "sha256-mCDw8V/Uzewm32rj+mkkm5atS5nJAFJ3ry1boTn+gqI=";
  };

  sourceRoot = "source/src";

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  patches = [
    ./0001-fix-instalation-paths.patch
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
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtwebsockets
    qtmultimedia
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
