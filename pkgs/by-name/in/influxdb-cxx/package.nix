{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2_3,
  libcpr,
  trompeloeil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "influxdb-cxx";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "offa";
    repo = "influxdb-cxx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5y9yRc69IH94Lmokp+XzXehQYkfj/vr3qnNmjTMylsg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libcpr
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
