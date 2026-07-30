{
  lib,
  stdenv,
  fetchzip,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  curlWithGnuTls,
  libev,
  libunwind,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clboss";
  version = "0.16.0";

  # The release tarball includes the pre-generated file `commit_hash.h` that is required for building
  src = fetchzip {
    url = "https://github.com/ZmnSCPxj/clboss/releases/download/v${finalAttrs.version}/clboss-v${finalAttrs.version}.tar.gz";
    hash = "sha256-hPrg3GlxURH208XB81UtHBb7jZtWF5Nc4Be7XZp57Dc=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    libev
    libunwind
    curlWithGnuTls
    sqlite
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Automated C-Lightning Node Manager";
    homepage = "https://github.com/ZmnSCPxj/clboss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "clboss";
  };
})
