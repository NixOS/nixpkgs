{
  lib,
  fetchFromGitHub,
  flutter324,
  webkitgtk_4_1,
  alsa-lib,
  libayatana-appindicator,
  autoPatchelfHook,
  wrapGAppsHook3,
  gst_all_1,
  stdenv,
  mimalloc,
  mpv,
  mpv-unwrapped,
}:
flutter324.buildFlutterApplication rec {
  pname = "kazumi";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "Kazumi";
    tag = version;
    hash = "sha256-CbfNvLJrGjJAWSeHejtHG0foSGmjpJtvbWvK994q4uQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    alsa-lib
    libayatana-appindicator
    mpv
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
  ];

  customSourceBuilders = {
    # unofficial media_kit_libs_linux
    media_kit_libs_linux =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "media_kit_libs_linux";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i '/set(MIMALLOC "mimalloc-/,/add_custom_target/d' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
          sed -i '/set(PLUGIN_NAME "media_kit_libs_linux_plugin")/i add_custom_target("MIMALLOC_TARGET" ALL DEPENDS ${mimalloc}/lib/mimalloc.o)' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
    # unofficial media_kit_video
    media_kit_video =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "media_kit_video";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i '/set(LIBMPV_ZIP_URL/,/if(MEDIA_KIT_LIBS_AVAILABLE)/{//!d; /set(LIBMPV_ZIP_URL/d}' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_HEADER_UNZIP_DIR "${mpv-unwrapped.dev}/include/mpv")' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_PATH "${mpv}/lib")' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_UNZIP_DIR "${mpv}/lib")' media_kit_video/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  gitHashes = {
    desktop_webview_window = "sha256-Z9ehzDKe1W3wGa2AcZoP73hlSwydggO6DaXd9mop+cM=";
    webview_windows = "sha256-9oWTvEoFeF7djEVA3PSM72rOmOMUhV8ZYuV6+RreNzE=";
    media_kit = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_android_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_ios_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_linux = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_macos_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_windows_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
  };

  postInstall = ''
    install -Dm0644 ./assets/linux/io.github.Predidit.Kazumi.desktop $out/share/applications/io.github.Predidit.Kazumi.desktop
    install -Dm0644 ./assets/images/logo/logo_linux.png $out/share/icons/hicolor/512x512/apps/io.github.Predidit.Kazumi.png
  '';

  meta = {
    description = "Watch Animes online with danmaku support";
    homepage = "https://github.com/Predidit/Kazumi";
    mainProgram = "kazumi";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
