{ lib
, fetchFromGitHub
, pkg-config
, flutter
, gst_all_1
, libunwind
, makeWrapper
, mimalloc
, orc
, nix-update-script
, mpv-unwrapped
, libplacebo
}:

flutter.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    rev = "v${version}";
    hash = "sha256-7zAcjek4iZRsNRVA85KBtU7PGbnLDZjnEO8Q5xwBiwM=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python. The frontend part";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
