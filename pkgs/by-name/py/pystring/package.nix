{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pystring";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "pystring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7U+OUbVL88nVSNeHBPAy8aGsLEd0lwm2I53mqYnoIkA=";
  };

  patches = [
    # fix for CMake v4
    # ref. https://github.com/imageworks/pystring/pull/47 merged upstream
    (fetchpatch {
      url = "https://github.com/imageworks/pystring/commit/e5df7dd77f239889713ab54fa5f23504759e252f.patch";
      hash = "sha256-ergkJOPLbCCYdrx3KqW7BSpzGC4tRvgT7tYPySKTVE4=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/imageworks/pystring/";
    description = "Collection of C++ functions which match the interface and behavior of python's string class methods using std::string";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.rytone ];
    platforms = lib.platforms.unix;
  };
})
