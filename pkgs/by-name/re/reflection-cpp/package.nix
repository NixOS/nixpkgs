{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reflection-cpp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "reflection-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q0h8p6xJ1UectRe656B6mT5+QokxR9N8rqzvgwUBugg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ static reflection support library";
    homepage = "https://github.com/contour-terminal/reflection-cpp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
