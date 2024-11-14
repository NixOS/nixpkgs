{
  lib,
  fetchFromGitHub,
  flutter,
  gst_all_1,
  libunwind,
  orc,
  webkitgtk_4_1,
}:
flutter.buildFlutterApplication rec {
  pname = "saber";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "saber-notes";
    repo = "saber";
    rev = "v${version}";
    hash = "sha256-vpL4Pp1nR6JlANCvo1u/o8yyzSQqtOjUF7Zr34ZitWU=";
  };

  gitHashes.json2yaml = "sha256-Vb0Bt11OHGX5+lDf8KqYZEGoXleGi5iHXVS2k7CEmDw=";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    gst_all_1.gstreamer.dev
    gst_all_1.gst-plugins-base.dev
    libunwind.dev
    orc.dev
    webkitgtk_4_1
  ];

  postInstall = ''
    install -Dm0644 ./flatpak/com.adilhanney.saber.desktop $out/share/applications/com.adilhanney.saber.desktop
    install -Dm0644 ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/com.adilhanney.saber.svg
  '';

  meta = {
    description = "The cross-platform open-source app built for handwriting";
    homepage = "https://github.com/saber-notes/saber";
    mainProgram = "saber";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
