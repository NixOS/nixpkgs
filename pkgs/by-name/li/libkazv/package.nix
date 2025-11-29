{
  lib,
  stdenv,
  fetchFromGitLab,
  boost,
  catch2_3,
  cmake,
  cryptopp,
  immer,
  lager,
  libcpr,
  libhttpserver,
  libmicrohttpd,
  nlohmann_json,
  pkg-config,
  vodozemac-bindings-cpp,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkazv";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "lily-is.land";
    owner = "kazv";
    repo = "libkazv";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rXQLbYPmD9UH0iXXqrAQSPF3KgIvjEyZ/97Q+/tl9Ec=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    cryptopp
    immer
    lager
    libcpr
    libhttpserver
    libmicrohttpd
    nlohmann_json
    vodozemac-bindings-cpp
    zug
  ];

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "libkazv_BUILD_TESTS" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;

  checkInputs = [ catch2_3 ];

  meta = {
    description = "Matrix client sdk built upon lager and the value-oriented design it enables";
    homepage = "https://lily-is.land/kazv/libkazv";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
