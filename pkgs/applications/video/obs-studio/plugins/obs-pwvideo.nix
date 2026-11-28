{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  obs-studio,
  pipewire,
  pkg-config,
  libdrm,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "obs-pwvideo";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "tasokait";
    repo = "obs-pwvideo";
    rev = finalAttrs.version;
    sha256 = "sha256-aUjYwaOiDbOLc5shjEj/LokzAoC2Bdta+GJvp9OV52U=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    obs-studio
    pipewire
    libdrm
    libGL
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=./lib"
    "-DCMAKE_INSTALL_DATADIR=./share"
  ];

  meta = {
    description = "OBS generic PipeWire video source";
    homepage = "https://github.com/tasokait/obs-pwvideo";
    maintainers = with lib.maintainers; [
      liquidnya
    ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
})
