{
  lib,
  fetchFromGitHub,
  flutter332,

  alsa-lib,
  libdisplay-info,
  libXpresent,
  libXScrnSaver,
  libepoxy,
  mpv-unwrapped,

  targetFlutterPlatform ? "web",
  baseUrl ? null,
}:

let
  flutter = flutter332;
in

flutter.buildFlutterApplication rec {
  pname = "fladder";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-aYKms5exK8A15MU694L7jDKMTH6+sWwMLDRuCwpp/eM=";
  };

  inherit targetFlutterPlatform;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    alsa-lib
    libdisplay-info
    mpv-unwrapped
    libXpresent
    libXScrnSaver
  ]
  ++ lib.optionals (targetFlutterPlatform == "linux") [
    libepoxy
  ];

  postInstall = lib.optionalString (targetFlutterPlatform == "web") (
    ''
      sed -i 's;base href="/";base href="$out";' $out/index.html
    ''
    + lib.optionalString (baseUrl != null) ''
      echo '{"baseUrl": "${baseUrl}"}' > $out/assets/config/config.json
    ''
  );

  meta = {
    description = "Simple Jellyfin Frontend built on top of Flutter";
    homepage = "https://github.com/DonutWare/Fladder";
    downloadPage = "https://github.com/DonutWare/Fladder/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "Fladder";
  };
}
