{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2_3,
  libcpr_1_10_5,
  trompeloeil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "influxdb-cxx";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "offa";
    repo = "influxdb-cxx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i7YnFjAuhtMGZ26rEObbm+kPmtwzBB0fyMlJLyR+LLI=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-warn "-Werror" ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libcpr_1_10_5
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    catch2_3
    trompeloeil
  ];

  cmakeFlags = [
    (lib.cmakeBool "INFLUXCXX_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "-E;BoostSupportTest") # requires network access
  ];

  doCheck = true;

  meta = {
    description = "InfluxDB C++ client library";
    homepage = "https://github.com/offa/influxdb-cxx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
