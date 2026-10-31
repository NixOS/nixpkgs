{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qt6Packages,
  ninja,
  pkg-config,
  gst_all_1,
  makeDesktopItem,
  copyDesktopItems,
  mpv-unwrapped,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anilibria-winmaclinux";
  version = "2.2.36";

  src = fetchFromGitHub {
    owner = "anilibria";
    repo = "anilibria-winmaclinux";
    tag = finalAttrs.version;
    hash = "sha256-2fwpLHEH1jlxl7r7QiVTHZniBO5k0GWaloNBynZJlTw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./0001-disable-version-check.patch
    (fetchpatch {
      # https://github.com/anilibria/anilibria-winmaclinux/pull/231
      name = "0002-do_not_override_pkg-config_when_building_via_nix.patch";
      url = "https://github.com/anilibria/anilibria-winmaclinux/commit/5ce7429c35fb05334496b5a200058b7952e9aef6.patch";
      hash = "sha256-OgQLOmHnRZiyH11YIoCx1XeIVLi6wWdoeuV9K80Lgio=";
      stripLen = 1;
    })
    (fetchpatch {
      name = "0003-fixed-qt6-folder-modal.patch";
      url = "https://github.com/anilibria/anilibria-winmaclinux/commit/adb4f7e5447d733fc3042f4bff25224ed726f3e6.patch";
      hash = "sha256-6/oXAObmXS+GKjjLNneMIj2gtKNvz6zHshWDYPv4agY=";
      stripLen = 1;
    })
  ];

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
    cmake
    pkg-config
    ninja
    qt6Packages.wrapQtAppsHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtwebsockets
    qt6Packages.qtmultimedia
    mpv-unwrapped.dev
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-base
    gst-libav
    gstreamer
  ]);

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/AniLiberty.app $out/Applications/
    makeWrapper $out/Applications/AniLiberty.app/Contents/MacOS/AniLiberty $out/bin/${finalAttrs.meta.mainProgram}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "AniLiberty";
      desktopName = "AniLiberty";
      icon = "aniliberty";
      comment = finalAttrs.meta.description;
      genericName = "AniLiberty (ex AniLibria) desktop client";
      categories = [
        "Qt"
        "Audio"
        "Video"
        "AudioVideo"
        "Player"
      ];
      keywords = [ "anime" ];
      exec = finalAttrs.meta.mainProgram;
      terminal = false;
    })
  ];

  meta = {
    homepage = "https://github.com/anilibria/anilibria-winmaclinux";
    description = "AniLiberty (ex AniLibria) cross platform desktop client, an anime theater for any computer you own";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    inherit (qt6Packages.qtbase.meta) platforms;
    mainProgram = "AniLiberty";
  };
})
