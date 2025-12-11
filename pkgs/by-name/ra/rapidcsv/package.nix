{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcsv";
  version = "8.90";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "rapidcsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0t2iURPBJpqt1Ndznuqg0qnnz574FtDAwyWTcYM1hBA=";
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
