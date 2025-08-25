{
  lib,
  flutter335,
  fetchFromGitHub,
  gst_all_1,
  libunwind,
  orc,
  webkitgtk_4_1,
  autoPatchelfHook,
  xorg,
  jdk,
  zlib,
  runCommand,
  yq,
  saber,
  _experimental-update-script-combinators,
  gitUpdater,
}:

let
  zlib-root = runCommand "zlib-root" { } ''
    mkdir $out
    ln -s ${zlib.dev}/include $out/include
    ln -s ${zlib}/lib $out/lib
  '';
in
flutter335.buildFlutterApplication rec {
  pname = "saber";
  version = "0.26.4";

  src = fetchFromGitHub {
    owner = "saber-notes";
    repo = "saber";
    tag = "v${version}";
    hash = "sha256-3QRcl/EenW3RJUvfpinWWUyG9fq6R6kZFnBGkqN7R7U=";
  };

  gitHashes = lib.importJSON ./gitHashes.json;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libunwind
    orc
    webkitgtk_4_1
    xorg.libXmu
    jdk
  ];

  postPatch = ''
    patchShebangs patches/remove_proprietary_dependencies.sh
    patches/remove_proprietary_dependencies.sh
  '';

  flutterBuildFlags = [ "--dart-define=DIRTY=false" ];

  env.ZLIB_ROOT = zlib-root;

  preBuild = ''
    cp ${./package_graph.json} .dart_tool/package_graph.json
  '';

  postInstall = ''
    install -Dm0644 flatpak/com.adilhanney.saber.desktop $out/share/applications/saber.desktop
    install -Dm0644 assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/com.adilhanney.saber.svg
    install -Dm0644 flatpak/com.adilhanney.saber.metainfo.xml -t $out/share/metainfo
  '';

  # Remove libpdfrx.so's reference to the /build/ directory
  preFixup = ''
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
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }
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
