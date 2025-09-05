{
  lib,
  flutter,
  fetchFromGitHub,
  sqlite,
  pkg-config,
  mpv-unwrapped,
  libunwind,
  libdovi,
}:
flutter.buildFlutterApplication rec {
  pname = "commet";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "commetchat";
    repo = "commet";
    rev = "v${version}";
    sha256 = "sha256-mr7oQvV1ZpYmJWtQvPg6s98qpB6wZIXrcrbYmOcZH8Q=";
  };

  gitHashes = {
    encrypted_url_preview = "sha256-AvN7pYHi7iqTSw7T3A+Ejij0GBuu7LJky1xBqpMHSQE=";
    flutter_highlighter = "sha256-Y84Besir3gu1RnQt9YoE0GyIJLLZ6H0Kki/Wf6z6QMg=";
    flutter_html = "sha256-6c/8aaQPxNJZI9pDWixnKlWrwRE3zn2e+HMmvahUKbQ=";
    flutter_local_notifications = "sha256-zIQXNEurNv43Otk+zjNjurrMFbLTTkEbVFhkA4QEQxo=";
    flutter_shortcuts = "sha256-WxjBK3Pg3plthkzY6hyAvvy8HoHPVmtVQ2Zd7LfjIpM=";
    matrix = "sha256-m0wy3wnNi9zrpmRFnQdfAcy0kKDQRUtK9dzLDIDlLaE=";
    matrix_dart_sdk_isar_db = "sha256-ItYzLuGklEdWzb/P4AAxPwEbOMoTqkaaRaAKlqgD8TM=";
    signal_sticker_api = "sha256-kA/yUIGwpPjgVJw1gVaZf4vJwvg0Y1Zl56m+qYdrW3U=";
  };

  patches = [ ./no-sqlite-libs.patch ];

  nativeBuildInput = [ pkg-config ];
  buildInputs = [
    sqlite.dev
    libunwind
    libdovi
    mpv-unwrapped
  ] ++ mpv-unwrapped.buildInputs;

  preBuild = ''
    dart run scripts/codegen.dart
  '';

  sourceRoot = "${src.name}/commet";

  pubspecLock = lib.importJSON ./pubspec.lock.json;
}
