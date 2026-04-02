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

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsran";
    rev = "release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
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

  cmakeFlags = [
    "-DENABLE_WERROR=OFF"
    (lib.cmakeBool "ENABLE_LTE_RATES" enableLteRates)
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
    description = "Open-source 4G and 5G software radio suite";
    license = lib.licenses.agpl3Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ hexagonal-sun ];
  };
})
