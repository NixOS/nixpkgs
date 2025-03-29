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
  olm,
  pkg-config,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkazv";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "lily-is.land";
    owner = "kazv";
    repo = "libkazv";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-bKujiuAR5otF7nc/BdVWVaEW9fSxdh2bcAgsQ5UO1Aw=";
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
    olm
    nlohmann_json
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
