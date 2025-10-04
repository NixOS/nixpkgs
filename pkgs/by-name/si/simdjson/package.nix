{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdjson";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8pmFtMpML7tTXbH1E3aIpSTQkNF8TFcIPOm2nwnKxkA=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "SIMDJSON_DEVELOPER_MODE" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optionals (with stdenv.hostPlatform; isPower && isBigEndian) [
    # Assume required CPU features are available, since otherwise we
    # just get a failed build.
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-mpower8-vector")
  ];

  meta = {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chessai ];
  };
})
