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
  version = "26.10";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsRAN_4G";
    tag = "release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "sha256-1Bd4vtdOSZFsZ7isVQ+u19u+CoGeAV7ZmMwH8INKaxw=";
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

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_WERROR" false)
    # The headers provided by UHD 4.10 use features introduced in C++17, and
    # srsRAN does not build with higher standard versions such as C++20.
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
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
