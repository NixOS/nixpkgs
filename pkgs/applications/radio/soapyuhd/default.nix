{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  uhd,
  boost,
  soapysdr,
  libobjc,
  IOKit,
  Security,
}:

stdenv.mkDerivation rec {
  pname = "soapyuhd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    rev = "soapy-uhd-${version}";
    sha256 = "14rk9ap9ayks2ma6mygca08yfds9bgfmip8cvwl87l06hwhnlwhj";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      uhd
      boost
      soapysdr
    ]
    ++ lib.optionals stdenv.isDarwin [
      libobjc
      IOKit
      Security
    ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for UHD devices";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}
