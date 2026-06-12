{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnatspec";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Etersoft";
    repo = "libnatspec";
    rev = "0.3.3-alt1";
    hash = "sha256-lg3kjrvv7G+nX6xlR7TQKvXqQJFcQTHarSpD0qYLZsw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ popt ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  propagatedBuildInputs = [ libiconv ];

  meta = {
    homepage = "https://github.com/Etersoft/libnatspec";
    description = "Library intended to smooth national specificities in using of programs";
    mainProgram = "natspec";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
    hasNoMaintainersButDependents = true;
  };
})
