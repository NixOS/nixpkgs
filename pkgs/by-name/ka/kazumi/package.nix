{
  lib,
  fetchFromGitHub,
  flutter,
  stdenv,
  webkitgtk_4_1,
  alsa-lib,
  libayatana-appindicator,
  libepoxy,
  autoPatchelfHook,
  wrapGAppsHook3,
  gst_all_1,
  at-spi2-atk,
  fetchurl,
}:
let
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "Kazumi";
    rev = version;
    hash = "sha256-LRlJo2zuE3Y3i4vBcjxIYQEDVJ2x85Fn77K4LVtTlg8=";
  };
  mdk-sdk = fetchurl {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v0.29.1/mdk-sdk-linux-x64.tar.xz";
    hash = "sha256-7dkvm5kP3gcQwXOE9DrjoOTzKRiwk/PVeRr7poLdCU0=";
  };
in
flutter.buildFlutterApplication {
  pname = "kazumi";

  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    alsa-lib
    at-spi2-atk
    libayatana-appindicator
    libepoxy
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
  ];

  customSourceBuilders = {
    flutter_volume_controller =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "flutter_volume_controller";
        inherit version src;
        inherit (src) passthru;
        postPatch = ''
          substituteInPlace linux/CMakeLists.txt \
            --replace-fail '# Include ALSA' 'find_package(PkgConfig REQUIRED)' \
            --replace-fail 'find_package(ALSA REQUIRED)' 'pkg_check_modules(ALSA REQUIRED alsa)'
        '';
        installPhase = ''
          runHook preInstall
          mkdir $out
          cp -r ./* $out/
          runHook postInstall
        '';
      };
    fvp =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "fvp";
        inherit version src;
        inherit (src) passthru;
        installPhase = ''
          runHook preInstall
          tar -xf ${mdk-sdk} -C ./linux
          mkdir $out
          cp -r ./* $out/
          runHook postInstall
        '';
      };
  };

  gitHashes = {
    desktop_webview_window = "sha256-Z9ehzDKe1W3wGa2AcZoP73hlSwydggO6DaXd9mop+cM=";
    webview_windows = "sha256-9oWTvEoFeF7djEVA3PSM72rOmOMUhV8ZYuV6+RreNzE=";
  };

  postInstall = ''
    mkdir -p $out/share/applications/ $out/share/icons/hicolor/512x512/apps/
    cp ./assets/linux/io.github.Predidit.Kazumi.desktop $out/share/applications
    cp ./assets/images/logo/logo_linux.png $out/share/icons/hicolor/512x512/apps/io.github.Predidit.Kazumi.png
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
