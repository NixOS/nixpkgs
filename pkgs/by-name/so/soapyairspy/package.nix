{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  airspy,
  soapysdr,
}:

stdenv.mkDerivation rec {
  pname = "soapyairspy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAirspy";
    rev = "soapy-airspy-${version}";
    sha256 = "0g23yybnmq0pg2m8m7dbhif8lw0hdsmnnjym93fdyxfk5iln7fsc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    airspy
    soapysdr
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyAirspy/commit/1be30c33b394fc4d2aeea4287e8df8701adad5a0.patch";
      hash = "sha256-ZEIyyd2tOK1diPh8BsEqALHGgdVCV6tZP9xeQNeeXl8=";
    })
    # CMake < 3.5 compat fix. Remove after (https://github.com/pothosware/SoapyAirspy/pull/31 is merged && next version bump).
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyAirspy/pull/31/commits/0ee4a5e8edff9f2bbea60dd069d2cc958e314a3e.patch";
      hash = "sha256-TQs4rDw+kRmxnuUwhhq9ioCsbKKniwuspSk/c7wazMM=";
    })
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for Airspy devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}
