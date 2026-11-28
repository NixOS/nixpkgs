{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  obs-studio,
  pipewire,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "obs-pipewire-audio-capture";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "obs-pipewire-audio-capture";
    rev = version;
    hash = "sha256-VSqPIqApzek3G17APJdpZW1OQi5kX7JLQ2XVGRyIFrY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    obs-studio
    pipewire
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=./lib"
    "-DCMAKE_INSTALL_DATADIR=./share"
    (lib.cmakeBool "LEGACY" (lib.versionOlder obs-studio.version "33"))
  ];

  meta = {
    description = "Audio device and application capture for OBS Studio using PipeWire";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with lib.maintainers; [
      Elinvention
      fazzi
    ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
