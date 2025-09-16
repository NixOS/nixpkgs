{
  fetchFromGitHub,
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

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    homepage = "https://github.com/schrodinger/coordgenlibs";
    changelog = "https://github.com/schrodinger/coordgenlibs/releases/tag/${finalAttrs.version}";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
})
