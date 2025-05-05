{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reflection-cpp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "reflection-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3TVoJkM+4RmB+KwWEpGo7gvzqCASNBmDHT+AzkR5KKk=";
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
