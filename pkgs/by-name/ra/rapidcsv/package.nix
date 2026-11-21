{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcsv";
  version = "9.09";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "rapidcsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gQ9j/BC88QYhSS1njgkb1+BH6kmDowUUi9+2OaT3/3Q=";
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
