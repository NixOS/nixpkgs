{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  catch2_3,
  libcpr_1_10_5,
  trompeloeil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "influxdb-cxx";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "offa";
    repo = "influxdb-cxx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UlCmaw2mWAL5PuNXXGQa602Qxlf5BCr7ZIiShffG74o=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
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

  meta = with lib; {
    description = "InfluxDB C++ client library";
    homepage = "https://github.com/offa/influxdb-cxx";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
