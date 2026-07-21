{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  pkg-config,
  fftwFloat,
  mbedtls,
  boost,
  lksctp-tools,
  libconfig,
  pcsclite,
  uhd,
  soapysdr-with-plugins,
  libbladeRF,
  zeromq,
  enableLteRates ? false,
  enableAvx ? stdenv.hostPlatform.avxSupport,
  enableAvx2 ? stdenv.hostPlatform.avx2Support,
  enableFma ? stdenv.hostPlatform.fmaSupport,
  enableAvx512 ? stdenv.hostPlatform.avx512Support,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srsran";
  version = "25_10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsRAN_4G";
    tag = "release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "sha256-DwQ4u17m8D5RqX3OIYSyeE5+51sLah1qchRcwlX5i0A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    mbedtls
    boost
    libconfig
    lksctp-tools
    pcsclite
    uhd
    soapysdr-with-plugins
    libbladeRF
    zeromq
  ];

  # boost 1.89 removed the boost_system stub library
  postPatch = ''
    substituteInPlace cmake/modules/FindUHD.cmake --replace-fail \
      'set(CMAKE_REQUIRED_LIBRARIES uhd boost_program_options boost_system)' \
      'set(CMAKE_REQUIRED_LIBRARIES uhd boost_program_options)'
    substituteInPlace lib/src/phy/rf/CMakeLists.txt --replace-fail \
      '/usr/lib/x86_64-linux-gnu/libboost_system.so' ""
    substituteInPlace CMakeLists.txt --replace-fail \
      'list(APPEND BOOST_REQUIRED_COMPONENTS "system")' ""
  '';

  cmakeFlags = [
    "-DENABLE_WERROR=OFF"
    (lib.cmakeBool "USE_LTE_RATES" enableLteRates)
    (lib.cmakeBool "ENABLE_AVX" enableAvx)
    (lib.cmakeBool "ENABLE_AVX2" enableAvx2)
    (lib.cmakeBool "ENABLE_FMA" enableFma)
    (lib.cmakeBool "ENABLE_AVX512" enableAvx512)
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    rm $out/lib/*.a
  '';

  meta = {
    homepage = "https://www.srslte.com/";
    changelog = "https://github.com/srsran/srsRAN_4G/releases/tag/${finalAttrs.src.tag}";
    description = "Open-source 4G software radio suite, including complete LTE UE, eNodeB and EPC applications";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hexagonal-sun
      felbinger
    ];
  };
})
