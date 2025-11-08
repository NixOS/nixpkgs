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
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "thewierdnut";
    repo = "asha_pipewire_sink";
    rev = "bbf665b9a3b90fcdbaeb092799ea3c5ba4347e31";
    hash = "sha256-PuJ6lBV7s5OqGe1X4wD7T+8LVMCFpgvM1pnMjXYr8gs=";
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
