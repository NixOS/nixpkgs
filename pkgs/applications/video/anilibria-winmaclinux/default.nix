{
  mkDerivation,
  lib,
  fetchFromGitHub,
  qmake,
  pkg-config,
  qtbase,
  qtquickcontrols2,
  qtwebsockets,
  qtmultimedia,
  gst_all_1,
  wrapQtAppsHook,
  makeDesktopItem,
  copyDesktopItems,

  withVLC ? true,
  libvlc,
  withMPV ? true,
  mpv-unwrapped,
}:

mkDerivation rec {
  pname = "anilibria-winmaclinux";
  version = "2.2.23";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    rev = version;
    hash = "sha256-RF0pe2G4K0uiqlOiAVESOi6bgwO0gJOh1VFkF7V3Wnc=";
  };

  sourceRoot = "${src.name}/src";

  qmakeFlags =
    [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optionals withVLC [ "CONFIG+=unixvlc" ]
    ++ lib.optionals withMPV [ "CONFIG+=unixmpv" ];

  patches = [
    ./0001-fix-installation-paths.patch
    ./0002-disable-version-check.patch
  ];

  preConfigure = ''
    substituteInPlace AniLibria.pro \
      --replace "\$\$PREFIX" '${placeholder "out"}'
  '';

  qtWrapperArgs = [
    "--prefix GST_PLUGIN_PATH : ${
      (
        with gst_all_1;
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
          gst-plugins-bad
          gst-plugins-good
          gst-plugins-base
          gst-libav
          gstreamer
        ]
      )
    }"
  ];

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs =
    [
      qtbase
      qtquickcontrols2
      qtwebsockets
      qtmultimedia
    ]
    ++ (with gst_all_1; [
      gst-plugins-bad
      gst-plugins-good
      gst-plugins-base
      gst-libav
      gstreamer
    ])
    ++ lib.optionals withVLC [ libvlc ]
    ++ lib.optionals withMPV [ mpv-unwrapped.dev ];

  desktopItems = [
    (makeDesktopItem (rec {
      name = "AniLibria";
      desktopName = name;
      icon = "anilibria";
      comment = meta.description;
      genericName = "AniLibria desktop client";
      categories = [
        "Qt"
        "AudioVideo"
        "Player"
      ];
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
