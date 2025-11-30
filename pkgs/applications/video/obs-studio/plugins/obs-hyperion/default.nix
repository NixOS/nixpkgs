{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  obs-studio,
  libGL,
  qtbase,
  flatbuffers,
}:

stdenv.mkDerivation rec {
  pname = "obs-hyperion";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = "hyperion-obs-plugin";
    rev = version;
    sha256 = "sha256-UAfjafoZhhhHRSo+eUBLhHaCmn2GYFcYyRb9wHIp/9I=";
  };

  nativeBuildInputs = [
    cmake
    flatbuffers
    pkg-config
  ];
  buildInputs = [
    obs-studio
    flatbuffers
    libGL
    qtbase
  ];

  dontWrapQtApps = true;

  patches = [ ./check-state-changed.patch ];

  cmakeFlags = [
    "-DOBS_SOURCE=${obs-studio.src}"
    "-DGLOBAL_INSTALLATION=ON"
    "-DUSE_SYSTEM_FLATBUFFERS_LIBS=ON"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  preConfigure = ''
    rm -rf external/flatbuffers
  '';

  meta = with lib; {
    description = "OBS Studio plugin to connect to a Hyperion.ng server";
    homepage = "https://github.com/hyperion-project/hyperion-obs-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ algram ];
    inherit (obs-studio.meta) platforms;
  };
}
