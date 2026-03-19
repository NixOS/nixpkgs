{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freebsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libipt";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hSC00GbVllJStgt9iA9WT54U8NQRtgJHuyZyb5ougc8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.hostPlatform.isFreeBSD freebsd.libstdthreads;

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    NIX_LDFLAGS = "-lstdthreads";
  };

  meta = {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
