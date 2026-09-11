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
  version = "0.17.3";

  # The release tarball includes the pre-generated file `commit_hash.h` that is required for building
  src = fetchzip {
    url = "https://github.com/ksedgwic/clboss/releases/download/v${finalAttrs.version}/clboss-v${finalAttrs.version}.tar.gz";
    hash = "sha256-KAe9E1C68afnwKYyvPJubcKHNhJiIAqPH4/hQxk9Ugw=";
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
    homepage = "https://github.com/ksedgwic/clboss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "clboss";
  };
})
