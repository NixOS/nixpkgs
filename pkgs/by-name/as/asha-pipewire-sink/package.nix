{
  cmake,
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  pipewire,
  bluez,
  glib,
}:

stdenv.mkDerivation {
  pname = "asha-pipewire-sink";
  version = "0-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "thewierdnut";
    repo = "asha_pipewire_sink";
    rev = "16a9c1cfba2d9aaa2cedbd86b4aa4f8e556736ae";
    hash = "sha256-9nfcFB37rBvgu0usySxovbxwQLrGCKDg6dk5kBU50C4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bluez.dev
    glib.dev
    pipewire.dev
  ];

  installPhase = ''
    install -Dm755 asha_connection_test snoop_analyze asha_stream_test asha_pipewire_sink -t $out/bin
  '';

  meta = {
    description = "Sample ASHA implementation for Linux designed to work with pipewire and bluez";
    homepage = "https://github.com/thewierdnut/asha_pipewire_sink";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "asha_pipewire_sink";
  };
}
