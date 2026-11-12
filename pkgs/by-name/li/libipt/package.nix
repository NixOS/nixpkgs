{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freebsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libipt";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ym2ARpO64FvCMOmQRVlT1UETGNfqqJFIK4qv1rW3uDw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.hostPlatform.isFreeBSD freebsd.libstdthreads;

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    NIX_LDFLAGS = "-lstdthreads";
  };

  meta = {
    changelog = "https://github.com/intel/libipt/releases/tag/v${finalAttrs.version}";
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
