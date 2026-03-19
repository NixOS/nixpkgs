{
  lib,
  flutter338,
  fetchFromGitHub,
}:

let
  version = "1.18.15";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "badgemagic-app";
    tag = "v${version}";
    hash = "sha256-zQ7ajVHueyCJP2n81dogM5YytxOoJ/hJt/qYbmw64e0=";
  };
in
flutter338.buildFlutterApplication {
  pname = "badgemagic-app";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    description = "Badge Magic with LEDs - mobile and desktop app";
    homepage = "https://github.com/fossasia/badgemagic-app";
    license = with lib.licenses; [ asl20 ];
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "badgemagic";
  };
}
