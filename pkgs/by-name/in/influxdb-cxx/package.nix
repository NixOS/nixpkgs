{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2_3,
<<<<<<< HEAD
  libcpr,
=======
  libcpr_1_10_5,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  trompeloeil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "influxdb-cxx";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "offa";
    repo = "influxdb-cxx";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-bP3Mfsv+20BfYiNdGFeNKHYdqGJSryrd7MWfqXjGnZw=";
  };

=======
    hash = "sha256-i7YnFjAuhtMGZ26rEObbm+kPmtwzBB0fyMlJLyR+LLI=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-warn "-Werror" ""
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
<<<<<<< HEAD
    libcpr
=======
    libcpr_1_10_5
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
