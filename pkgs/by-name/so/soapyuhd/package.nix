{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  uhd,
  boost,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyuhd";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    tag = "soapy-uhd-${finalAttrs.version}";
    hash = "sha256-keIZysr40LAscSKyfbSFQ4+t9oiPjwS4RbXr8Mgb2cc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    uhd
    boost
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt
  '';

  meta = {
    homepage = "https://github.com/pothosware/SoapyUHD";
    description = "SoapySDR plugin for UHD devices";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
})
