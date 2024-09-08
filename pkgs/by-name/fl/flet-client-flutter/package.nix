{ lib
, fetchFromGitHub
, pkg-config
, flutter
, gst_all_1
, libunwind
, makeWrapper
, mimalloc
, orc
, yq
, runCommand
, gitUpdater
, mpv-unwrapped
, libplacebo
, _experimental-update-script-combinators
, flet-client-flutter
}:

flutter.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    rev = "v${version}";
    hash = "sha256-cT1cWxMVpZ0fXoIaJpW96ifQKNe7+PLUXjIFJ3ALdyo=";
  };

  sourceRoot = "${src.name}/client";

  cmakeFlags = [
    "-DMIMALLOC_LIB=${mimalloc}/lib/mimalloc.o"
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    makeWrapper
    mimalloc
    pkg-config
  ];

  buildInputs = [
    mpv-unwrapped
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    libunwind
    orc
    mimalloc
  ]
    ++ mpv-unwrapped.buildInputs
    ++ libplacebo.buildInputs
  ;

  passthru = {
    pubspecSource = runCommand "pubspec.lock.json" {
        buildInputs = [ yq ];
        inherit (flet-client-flutter) src;
      } ''
      cat $src/client/pubspec.lock | yq > $out
    '';

    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "flet-client-flutter.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Framework that enables you to easily build realtime web, mobile, and desktop apps in Python. The frontend part";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
