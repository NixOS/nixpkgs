{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, catch2_3, libcpr, trompeloeil }:

stdenv.mkDerivation (finalAttrs: {
  pname = "influxdb-cxx";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "offa";
    repo = "influxdb-cxx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DFslPrbgqS3JGx62oWlsC+AN5J2CsFjGcDaDRCadw7E=";
  };

  patches = [
    # Fix unclosed test case tag
    (fetchpatch {
      url = "https://github.com/offa/influxdb-cxx/commit/b31f94982fd1d50e89ce04f66c694bec108bf470.patch";
      hash = "sha256-oSdpNlWV744VpzfiWzp0ziNKaReLTlyfJ+SF2qyH+TU=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libcpr ]
    ++ lib.optionals finalAttrs.doCheck [ catch2_3 trompeloeil ];

  cmakeFlags = [
    (lib.cmakeBool "INFLUXCXX_TESTING" finalAttrs.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "-E;BoostSupportTest") # requires network access
  ];

  doCheck = true;

  meta = with lib; {
    description = "InfluxDB C++ client library";
    homepage = "https://github.com/offa/influxdb-cxx";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
