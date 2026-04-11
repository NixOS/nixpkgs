{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmowgli";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "libmowgli-2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jlw6ixMoIdIjmQ86N+KN+Gez218sw894POkcCYnT0s0=";
  };

  meta = {
    description = "Development framework for C providing high performance and highly flexible algorithms";
    homepage = "https://github.com/atheme/libmowgli-2";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
