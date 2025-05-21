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

stdenv.mkDerivation rec {
  pname = "srsran";
  version = "23.11";

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsran";
    rev = "release_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-3cQMZ75I4cyHpik2d/eBuzw7M4OgbKqroCddycw4uW8=";
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

  meta = with lib; {
    homepage = "https://www.srslte.com/";
    description = "Open-source 4G and 5G software radio suite";
    license = licenses.agpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ hexagonal-sun ];
  };
}
