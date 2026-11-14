{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcsv";
  version = "9.07";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "rapidcsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pU9vQAqftIV54+5aUxedomw+g8tUV1iGeHsLL70OuuI=";
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
