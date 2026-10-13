{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zlib,
  curl,
  expat,
  fuse3,
  openssl,
  autoreconfHook,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.7.22";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-pGInhJQBhFJhft/KfB3J3S9/BVp9D8TZ+uw2CUNVC+Q=";
  };

  patches = [
    # libafflib.so fails to link due to undefined references when using GCC 16.
    # https://github.com/sshock/AFFLIBv3/issues/60
    (fetchpatch {
      name = "gcc16-missing-declarations.patch";
      url = "https://github.com/sshock/AFFLIBv3/commit/f35df6c1d2610e3233c30d50054c00e29d7d5a23.patch";
      hash = "sha256-D7/PnePwb7ikuHIo+3MBPp4PI8uN8vNJ1rZykeXDdxU=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    curl
    expat
    openssl
    python3
    fuse3
  ];

  env.CFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0";

  meta = {
    homepage = "http://afflib.sourceforge.net/";
    description = "Advanced forensic format library";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.raskin ];
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
})
