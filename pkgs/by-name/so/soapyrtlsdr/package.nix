{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  rtl-sdr,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyrtlsdr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtl-sdr-${finalAttrs.version}";
    sha256 = "sha256-IapdrBE8HhibY52Anm76/mVAoA0GghwnRCxxfGkyLTw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    rtl-sdr
    soapysdr
  ];

  patches = [
    (fetchpatch2 {
      name = "cmake-update.patch";
      url = "https://github.com/pothosware/SoapyRTLSDR/commit/448c9d0d326c2600905b7ce84222ff9d72ba2189.patch?full_index=1";
      hash = "sha256-hWlNowkf9yZM6p+EGh+IiUm2JfG5mLe8Qq8gTVIdIak=";
    })

    (fetchpatch2 {
      name = "fix-cmake4-build.patch";
      url = "https://github.com/pothosware/SoapyRTLSDR/commit/bb2d1511b957138051764c9193a3d6971e912b85.patch?full_index=1";
      hash = "sha256-C90B5WMjx1lJKiX0F/cAfGmz2WRc2BA84FTmVmnC+DI=";
    })
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyRTLSDR";
    description = "SoapySDR plugin for RTL-SDR devices";
    license = licenses.mit;
    maintainers = with maintainers; [
      ragge
      luizribeiro
    ];
    platforms = platforms.unix;
  };
})
