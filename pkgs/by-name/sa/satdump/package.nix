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
  curl,
  # Optional dependencies
  withZIQRecordingCompression ? true,
  zstd,
  withGUI ? true,
  glfw,
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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "SatDump";
    repo = "SatDump";
    tag = finalAttrs.version;
    hash = "sha256-+Sne+NMwnIAs3ff64fBHAIE4/iDExIC64sXtO0LJwI0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      fftwFloat
      libpng
      libtiff
      jemalloc
      volk
      nng
      curl
    ]
    ++ lib.optional withZIQRecordingCompression zstd
    ++ lib.optionals withGUI [
      glfw
      zenity
    ]
    ++ lib.optional withAudio portaudio
    ++ lib.optional withOfficialProductSupport hdf5
    ++ lib.optionals withOpenCL [
      opencl-headers
      ocl-icd
    ]
    ++ lib.optional withSourceRtlsdr rtl-sdr-librtlsdr
    ++ lib.optional withSourceHackRF hackrf
    ++ lib.optional withSourceAirspy airspy
    ++ lib.optional withSourceAirspyHF airspyhf
    ++ lib.optionals withSourceAD9361 [
      libad9361
      libiio
    ]
    ++ lib.optional withSourceBladeRF libbladeRF;

  cmakeFlags = lib.optional (!withGUI) "-DBUILD_GUI=OFF";

  postPatch = ''
    substituteInPlace src-core/CMakeLists.txt \
      --replace-fail '$'{CMAKE_INSTALL_PREFIX}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A generic satellite data processing software";
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
