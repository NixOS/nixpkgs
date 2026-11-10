{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reflection-cpp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "reflection-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ylaAS0zlkiJlBwibFBIyNOQ2h6IGRXTiKV1g6So9M9s=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ static reflection support library";
    homepage = "https://github.com/contour-terminal/reflection-cpp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
