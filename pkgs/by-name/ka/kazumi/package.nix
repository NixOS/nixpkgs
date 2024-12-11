{
  lib,
  fetchFromGitHub,
  flutter,
  webkitgtk_4_1,
  alsa-lib,
  libayatana-appindicator,
  libepoxy,
  autoPatchelfHook,
  wrapGAppsHook3,
  gst_all_1,
  at-spi2-atk,
}:
let
  version = "1.4.4";
in
flutter.buildFlutterApplication {
  pname = "kazumi";
  inherit version;

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "Kazumi";
    rev = "refs/tags/${version}";
    hash = "sha256-p5eFabIa04io180tBNCMRs2pX7HU8b+PdyBwZohmKR8=";
  };

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

  gitHashes = {
    desktop_webview_window = "sha256-Z9ehzDKe1W3wGa2AcZoP73hlSwydggO6DaXd9mop+cM=";
    webview_windows = "sha256-9oWTvEoFeF7djEVA3PSM72rOmOMUhV8ZYuV6+RreNzE=";
  };

  postInstall = ''
    mkdir -p $out/share/applications/ $out/share/icons/hicolor/512x512/apps/
    install -Dm0644 ./assets/linux/io.github.Predidit.Kazumi.desktop $out/share/applications/io.github.Predidit.Kazumi.desktop
    install -Dm0644 ./assets/images/logo/logo_linux.png $out/share/icons/hicolor/512x512/apps/io.github.Predidit.Kazumi.png
  '';

  meta = {
    description = "Watch Animes online with danmaku support";
    homepage = "https://github.com/Predidit/Kazumi";
    mainProgram = "kazumi";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
