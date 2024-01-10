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
, libvlc
}:

mkDerivation rec {
  pname = "anilibria-winmaclinux";
  version = "1.2.12";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    rev = version;
    sha256 = "sha256-J9MBnHrVnDaJ8Ykf/n8OkWKbK/JfMxorH9E+mKe3T8k=";
  };

  sourceRoot = "source/src";

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  patches = [
    ./0001-fix-installation-paths.patch
    ./0002-disable-version-check.patch
    ./0003-build-with-vlc.patch
  ];

  preConfigure = ''
    substituteInPlace AniLibria.pro \
      --replace "\$\$PREFIX" '${placeholder "out"}' \
      --replace '@VLC_PATH@' '${libvlc}/include'
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
