{
  lib,
  fetchFromGitHub,
  flutter332,

  libdisplay-info,
  mpv,
  xorg,

  baseUrl ? null,
}:

let
  flutter = flutter332;
in

flutter.buildFlutterApplication {
  pname = "fladder";
  version = "0.7.0-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    rev = "f3e920ac79b18132f2d1944f3f29743959cdbb70";
    hash = "sha256-SfRu1IHpIsKajOMg3sxOXqOoRuDdSY1hZtgeuqgU0oc=";
  };

  targetFlutterPlatform = "web";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    libdisplay-info
    mpv
    xorg.libXpresent
    xorg.libXScrnSaver
  ];

  fixupPhase =
    ''
      runHook preFixup

      sed -i 's;base href="/";base href="$out";' $out/index.html
    ''
    + lib.optionalString (baseUrl != null) ''
      echo '{"baseUrl": "${baseUrl}"}' > $out/assets/config/config.json
    ''
    + ''
      runHook postFixup
    '';

  meta = {
    description = "Simple Jellyfin Frontend built on top of Flutter";
    homepage = "https://github.com/DonutWare/Fladder";
    downloadPage = "https://github.com/DonutWare/Fladder/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "Fladder";
  };
}
