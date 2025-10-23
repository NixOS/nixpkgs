{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcsv";
  version = "8.89";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "rapidcsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xs9dNpOU6ZcbYX9AfkWkwMb/Bc7s2GTMUTDOBaO7VDM=";
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
