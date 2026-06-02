{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  bison,
  cmake,
  zlib,
}:

stdenv.mkDerivation {
  version = "2023-09-03";
  pname = "pbrt-v3";

  src = fetchFromGitHub {
    rev = "13d871faae88233b327d04cda24022b8bb0093ee";
    owner = "mmp";
    repo = "pbrt-v3";
    hash = "sha256-xg99l1o4MychQiOYkfsvD9vO0ysfmgQyaNaf8oqoWzk=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  nativeBuildInputs = [
    flex
    bison
    cmake
  ];
  buildInputs = [ zlib ];

  meta = {
    homepage = "https://pbrt.org/";
    description = "Renderer described in the third edition of the book 'Physically Based Rendering: From Theory To Implementation'";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.juliendehos ];
    priority = 10;
  };
}
