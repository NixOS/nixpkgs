{
  lib,
  flutter329,
  fetchFromGitHub,
  gst_all_1,
  libunwind,
  orc,
  webkitgtk_4_1,
  autoPatchelfHook,
  xorg,
  runCommand,
  yq,
  saber,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter329.buildFlutterApplication rec {
  pname = "saber";
  version = "0.25.6";

  src = fetchFromGitHub {
    owner = "saber-notes";
    repo = "saber";
    tag = "v${version}";
    hash = "sha256-OknqEbWAYLlxSTDWcggM6GP2V8cdKIAksbm7TmKzjKY=";
  };

  gitHashes = {
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    json2yaml = "sha256-Vb0Bt11OHGX5+lDf8KqYZEGoXleGi5iHXVS2k7CEmDw=";
    workmanager = "sha256-fpB8CwNIn+HCQujyIXciq7Y9yd78Ie0IjkSewv3u5iw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libunwind
    orc
    webkitgtk_4_1
    xorg.libXmu
  ];

  postInstall = ''
    install -Dm0644 flatpak/com.adilhanney.saber.desktop $out/share/applications/saber.desktop
    install -Dm0644 assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/com.adilhanney.saber.svg
  '';

  preFixup = ''
    # Remove libpdfrx.so's reference to the /build/ directory
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/saber/lib/lib*.so
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (saber) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "saber.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Cross-platform open-source app built for handwriting";
    homepage = "https://github.com/saber-notes/saber";
    mainProgram = "saber";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
