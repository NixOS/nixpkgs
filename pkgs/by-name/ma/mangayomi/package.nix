{
  lib,
  fetchFromGitHub,
  flutter324,
  pkg-config,
  webkitgtk_4_1,
  mpv,
  libass,
  ffmpeg,
  libplacebo,
  libunwind,
  shaderc,
  vulkan-loader,
  lcms,
  libdovi,
  libdvdnav,
  libdvdread,
  mujs,
  libbluray,
  lua,
  rubberband,
  libuchardet,
  zimg,
  alsa-lib,
  openal,
  pipewire,
  libpulseaudio,
  libcaca,
  libdrm,
  mesa,
  libXScrnSaver,
  nv-codec-headers-11,
  libXpresent,
  libva,
  libvdpau,
  rustPlatform,
  stdenv,
  xdg-user-dirs,
  zenity,
  copyDesktopItems,
  makeDesktopItem,
  replaceVars,
}:
let
  pname = "mangayomi";
  version = "0.3.75";
  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-kVAtUXEysaCJSLobXlgAgK59pgLq8Ze/XDqQNNdKdzg=";
  };
  rustDep = rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/rust";

    cargoHash = "sha256-b4PRFe8FgP/PXHwSw2qmderPRFCBC1ISQuf8uZcsxpY=";

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";
  };
in
flutter324.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  customSourceBuilders = {
    rust_lib_mangayomi =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "rust_lib_mangayomi";
        inherit version src;
        inherit (src) passthru;

        patches = [
          (replaceVars ./cargokit.patch {
            output_lib = "${rustDep}/${rustDep.passthru.libraryPath}";
          })
        ];

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  gitHashes = {
    desktop_webview_window = "sha256-Z9ehzDKe1W3wGa2AcZoP73hlSwydggO6DaXd9mop+cM=";
    flutter_qjs = "sha256-m+Z0bCswylfd1E2Y6X6bdPivkSlXUxO4J0Icbco+/0A=";
    media_kit_libs_windows_video = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
    media_kit_native_event_loop = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
    media_kit_video = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_1
    mpv
    libass
    ffmpeg
    libplacebo
    libunwind
    shaderc
    vulkan-loader
    lcms
    libdovi
    libdvdnav
    libdvdread
    mujs
    libbluray
    lua
    rubberband
    libuchardet
    zimg
    alsa-lib
    openal
    pipewire
    libpulseaudio
    libcaca
    libdrm
    mesa
    libXScrnSaver
    libXpresent
    nv-codec-headers-11
    libva
    libvdpau
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "mangayomi";
      exec = "mangayomi";
      icon = "mangayomi";
      genericName = "Mangayomi";
      desktopName = "Mangayomi";
      categories = [
        "Utility"
      ];
      keywords = [
        "Manga"
        "Anime"
        "BitTorrent"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/app_icons/icon-red.png $out/share/pixmaps/mangayomi.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib" \
    --prefix PATH : "${
      lib.makeBinPath [
        xdg-user-dirs
        zenity
      ]
    }"
  '';

  meta = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${version}";
    description = "Read manga and stream anime from a variety of sources including BitTorrent";
    homepage = "https://github.com/kodjodevf/mangayomi";
    mainProgram = "mangayomi";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
