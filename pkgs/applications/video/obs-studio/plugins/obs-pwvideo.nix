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
stdenv.mkDerivation rec {
  pname = "obs-pwvideo";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "hoshinolina";
    repo = "obs-pwvideo";
    rev = version;
    sha256 = "sha256-CCzeK5JyCWnIcty5xaDV5uCxvrMVx50f8SoLZnlF658=";
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
    homepage = "https://github.com/hoshinolina/obs-pwvideo";
    maintainers = with lib.maintainers; [
      liquidnya
    ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
