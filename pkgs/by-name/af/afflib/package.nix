{
  lib,
  stdenv,
  fetchFromGitHub,
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
