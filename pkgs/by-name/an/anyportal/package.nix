{
  lib,
  flutter332,
  fetchurl,
  fetchFromGitHub,
  protobuf,
  libayatana-appindicator,
  copyDesktopItems,
  autoPatchelfHook,
  protoc-gen-dart,
  makeDesktopItem,
  runCommand,
  yq,
  anyportal,
  _experimental-update-script-combinators,
  gitUpdater,
}:

let
  sqlite3-wasm = fetchurl {
    url = "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3_flutter_libs-0.5.34/sqlite3.wasm";
    hash = "sha256-NRA8bxI3dO90AC28yncTsUiJRUHow38Pg6qDus2qEv8=";
  };
  drift_worker-js = fetchurl {
    url = "https://github.com/simolus3/drift/releases/download/drift-2.27.0/drift_worker.js";
    hash = "sha256-SgDd1A0yz7gTtlfFn8N/vo/r3pD5shBSEj5RZAYo0wk=";
  };
in
flutter332.buildFlutterApplication rec {
  pname = "anyportal";
  version = "0.5.31+73";

  src =
    (fetchFromGitHub {
      owner = "AnyPortal";
      repo = "AnyPortal";
      tag = "v${version}";
      hash = "sha256-khS2G6nEP3w4zKK7MMklLrgrqyB8RqnBbQdtNlGeuZ4=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    protobuf
    protoc-gen-dart
  ];

  buildInputs = [ libayatana-appindicator ];

  # web: method 'getApplicationCacheDirectory' isn't defined for the class 'GlobalManager'
  targetFlutterPlatform = "linux";

  # no `/build/source/.dart_tool/flutter_gen/pubspec.yaml` found
  postPatch = ''
    substituteInPlace pubspec.yaml \
      --replace-fail "generate: true" "generate: false"
  '';

  preBuild =
    ''
      substituteInPlace pubspec.yaml \
        --replace-fail "generate: false" "generate: true"
      packageRun build_runner build
      mkdir -p lib/generated/grpc/v2ray-core
      protoc \
        --experimental_allow_proto3_optional \
        --dart_out=grpc:lib/generated/grpc/v2ray-core \
        --proto_path=third_party/v2ray-core \
        $(find third_party/v2ray-core -name "*.proto")
    ''
    # wait upstream support
    # https://github.com/AnyPortal/AnyPortal/blob/v0.5.31%2B73/.github/workflows/build.yml
    + lib.optionalString (targetFlutterPlatform == "web") ''
      cp ${sqlite3-wasm} web/sqlite3.wasm
      cp ${drift_worker-js} web/drift_worker.js
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "anyportal";
      exec = "anyportal %U";
      icon = "anyportal";
      desktopName = "AnyPortal";
    })
  ];

  postInstall = ''
    install -Dm644 assets/icon/icon.png $out/share/pixmaps/anyportal.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (anyportal) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "anyportal.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "GUI for v2ray, xray, sing-box";
    homepage = "https://github.com/AnyPortal/AnyPortal";
    mainProgram = "anyportal";
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
