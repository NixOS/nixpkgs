{
  lib,
  alsa-lib,
  cmake,
  darwin,
  fetchFromGitHub,
  stdenv,
}:

let
  inherit (darwin.apple_sdk.frameworks)
    CoreAudio
    CoreFoundation
    CoreMIDI
    CoreServices
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libremidi";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "jcelerier";
    repo = "libremidi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-raVBJ75/UmM3P69s8VNUXRE/2jV4WqPIfI4eXaf6UEg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreAudio
      CoreFoundation
      CoreMIDI
      CoreServices
    ];

  # Bug: set this as true breaks obs-studio-plugins.advanced-scene-switcher
  strictDeps = false;

  postInstall = ''
    cp -r $src/include $out
  '';

  meta = {
    homepage = "https://github.com/jcelerier/libremidi";
    description = "Modern C++ MIDI real-time & file I/O library";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
