{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  pkg-config,
  gst_all_1,
  makeDesktopItem,
  copyDesktopItems,

  withVLC ? true,
  libvlc,
  withMPV ? true,
  mpv-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anilibria-winmaclinux";
  version = "2.2.34";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    tag = finalAttrs.version;
    hash = "sha256-58NFlB6viWXG13J+RBzMj6LlYFClpWpGQ/aCNxJ5wKQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  qmakeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
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
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols2
    libsForQt5.qtwebsockets
    libsForQt5.qtmultimedia
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
    (makeDesktopItem {
      name = "AniLibria";
      desktopName = "AniLibria";
      icon = "anilibria";
      comment = finalAttrs.meta.description;
      genericName = "AniLibria desktop client";
      categories = [
        "Qt"
        "AudioVideo"
        "Player"
      ];
      keywords = [ "anime" ];
      exec = "AniLibria";
      terminal = false;
    })
  ];

  meta = {
    homepage = "https://github.com/anilibria/anilibria-winmaclinux";
    description = "AniLibria cross platform desktop client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    inherit (libsForQt5.qtbase.meta) platforms;
    mainProgram = "AniLibria";
  };
})
