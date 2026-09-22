{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcsv";
  version = "8.99";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "rapidcsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TJ4IpBt2G+zUf2AEUB9wwz8Zk1UEoqqoemTVJCB+8D0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ CSV parser library";
    homepage = "https://github.com/d99kris/rapidcsv";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.szanko ];
    platforms = lib.platforms.all;
  };
})
