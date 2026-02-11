{
  lib,
  fetchFromGitHub,
  flutter335,

  alsa-lib,
  libdisplay-info,
  libxpresent,
  libxscrnsaver,
  libepoxy,
  mpv-unwrapped,

  targetFlutterPlatform ? "web",
  baseUrl ? null,
}:

let
  flutter = flutter335;

  media_kit_hash = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
in

flutter.buildFlutterApplication rec {
  pname = "fladder";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-IX3qbIgfi9d8rP24yIGlBzi5l28YQWnvLD+dD+7uIZc=";
  };

  inherit targetFlutterPlatform;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    media_kit = media_kit_hash;
    media_kit_video = media_kit_hash;
    media_kit_libs_linux = media_kit_hash;
    media_kit_libs_video = media_kit_hash;
    media_kit_libs_android_video = media_kit_hash;
    media_kit_libs_ios_video = media_kit_hash;
    media_kit_libs_macos_video = media_kit_hash;
    media_kit_libs_windows_video = media_kit_hash;
  };

  buildInputs = [
    alsa-lib
    libdisplay-info
    mpv-unwrapped
    libxpresent
    libxscrnsaver
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
