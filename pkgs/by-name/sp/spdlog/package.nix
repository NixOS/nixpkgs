{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt,
  catch2_3,
  staticBuild ? stdenv.hostPlatform.isStatic,

  # tests
  bear,
  tiledb,
}:

stdenv.mkDerivation rec {
  pname = "spdlog";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v${version}";
    hash = "sha256-F7khXbMilbh5b+eKnzcB0fPPWQqUHqAYPWJb83OnUKQ=";
  };

  nativeBuildInputs = [ cmake ];
  # Required to build tests, even if they aren't executed
  buildInputs = [ catch2_3 ];
  propagatedBuildInputs = [ fmt ];

  cmakeFlags = [
    "-DSPDLOG_BUILD_SHARED=${if staticBuild then "OFF" else "ON"}"
    "-DSPDLOG_BUILD_STATIC=${if staticBuild then "ON" else "OFF"}"
    "-DSPDLOG_BUILD_EXAMPLE=OFF"
    "-DSPDLOG_BUILD_BENCH=OFF"
    "-DSPDLOG_BUILD_TESTS=ON"
    "-DSPDLOG_FMT_EXTERNAL=ON"
  ];

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  postInstall = ''
    mkdir -p $out/share/doc/spdlog
    cp -rv ../example $out/share/doc/spdlog
  '';

  doCheck = true;

  passthru.tests = {
    inherit bear tiledb;
  };

  meta = with lib; {
    description = "Very fast, header only, C++ logging library";
    homepage = "https://github.com/gabime/spdlog";
    license = licenses.mit;
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.all;
  };
}
