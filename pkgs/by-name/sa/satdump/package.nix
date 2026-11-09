{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  # required dependencies
  fftwFloat,
  libpng,
  libtiff,
  jemalloc,
  volk,
  nng,
  sqlite,
  curl,
  # Optional dependencies
  withZIQRecordingCompression ? true,
  zstd,
  withGUI ? true,
  dbus,
  glfw,
  libx11,
  libxrandr,
  zenity,
  withAudio ? true,
  portaudio,
  withOfficialProductSupport ? true,
  hdf5,
  withOpenCL ? true,
  opencl-headers,
  ocl-icd,
  withSourceRtlsdr ? true,
  rtl-sdr-librtlsdr,
  withSourceHackRF ? true,
  hackrf,
  withSourceAirspy ? true,
  airspy,
  withSourceAirspyHF ? true,
  airspyhf,
  withSourceAD9361 ? true,
  libad9361,
  libiio,
  withSourceBladeRF ? true,
  libbladeRF,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "satdump";
  version = "2.0.0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "SatDump";
    repo = "SatDump";
    rev = "19b73529f16f30776f190cba2abe4ded478f5c8e";
    hash = "sha256-xfKfxrhTRBFdhirBjGO2CeT1ZmaPRyAGFB7ILu+YZnA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    libpng
    libtiff
    jemalloc
    volk
    nng
    sqlite
    curl
  ]
  ++ lib.optionals withZIQRecordingCompression [ zstd ]
  ++ lib.optionals withGUI [
    dbus
    glfw
    libx11
    libxrandr
    zenity
  ]
  ++ lib.optionals withAudio [ portaudio ]
  ++ lib.optionals withOfficialProductSupport [ hdf5 ]
  ++ lib.optionals withOpenCL [
    opencl-headers
    ocl-icd
  ]
  ++ lib.optionals withSourceRtlsdr [ rtl-sdr-librtlsdr ]
  ++ lib.optionals withSourceHackRF [ hackrf ]
  ++ lib.optionals withSourceAirspy [ airspy ]
  ++ lib.optionals withSourceAirspyHF [ airspyhf ]
  ++ lib.optionals withSourceAD9361 [
    libad9361
    libiio
  ]
  ++ lib.optionals withSourceBladeRF [ libbladeRF ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_GUI" withGUI) ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generic satellite data processing software";
    homepage = "https://www.satdump.org/";
    changelog = "https://github.com/SatDump/SatDump/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      theverygaming
    ];
    mainProgram = "satdump";
  };
})
