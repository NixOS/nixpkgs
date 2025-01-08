{
  lib,
  fetchFromGitHub,
  flutter327,
  gst_all_1,
  libunwind,
  orc,
  webkitgtk_4_1,
  autoPatchelfHook,
  xorg,
}:
flutter327.buildFlutterApplication rec {
  pname = "saber";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "saber-notes";
    repo = "saber";
    tag = "v${version}";
    hash = "sha256-plBcZo67/x8KcND28jqfrwbvI9IZz8ptLZoGl2y2vW4=";
  };

  gitHashes = {
    receive_sharing_intent = "sha256-ppKPBL2ZOx2MeuLY6Q8aiVGsektK+Mqtwyxps0aNtwk=";
    json2yaml = "sha256-Vb0Bt11OHGX5+lDf8KqYZEGoXleGi5iHXVS2k7CEmDw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libunwind
    orc
    webkitgtk_4_1
    xorg.libXmu
  ];

  postInstall = ''
    install -Dm0644 ./flatpak/com.adilhanney.saber.desktop $out/share/applications/com.adilhanney.saber.desktop
    install -Dm0644 ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/com.adilhanney.saber.svg
  '';

  preFixup = ''
    # Remove libpdfrx.so's reference to the /build/ directory
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/saber/lib/lib*.so
  '';

  meta = {
    description = "Cross-platform open-source app built for handwriting";
    homepage = "https://github.com/saber-notes/saber";
    mainProgram = "saber";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
