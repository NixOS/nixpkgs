{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  boost,
  zlib,
  cmake,
  maeparser,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coordgenlibs";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "coordgenlibs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-casFPNbPv9mkKpzfBENW7INClypuCO1L7clLGBXvSvI=";
  };

  patches = [
    (fetchpatch {
      name = "coordgenlibs-fix-unused-but-set-variable.patch";
      url = "https://github.com/schrodinger/coordgenlibs/commit/6a1485643feb71c6d609d263f28751004c733cf7.patch";
      hash = "sha256-x34v+XumVip43LYb4bEkdqPFcTRTeC/zsRuQjnrh2zw=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    zlib
    maeparser
  ];

  # Fix the build with CMake 4.
  #
  # See: <https://github.com/schrodinger/coordgenlibs/pull/130>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.2)' \
        'cmake_minimum_required(VERSION 3.5)'
  '';

  doCheck = true;

  # Fix the build with Clang 20.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=deprecated-literal-operator";

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    homepage = "https://github.com/schrodinger/coordgenlibs";
    changelog = "https://github.com/schrodinger/coordgenlibs/releases/tag/${finalAttrs.version}";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
})
