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

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-unused-but-set-variable";
  };

  doCheck = true;

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    homepage = "https://github.com/schrodinger/coordgenlibs";
    changelog = "https://github.com/schrodinger/coordgenlibs/releases/tag/${finalAttrs.version}";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
})
