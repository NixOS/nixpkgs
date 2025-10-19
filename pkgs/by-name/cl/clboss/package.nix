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

stdenv.mkDerivation rec {
  pname = "clboss";
  version = "0.15.1";

  # The release tarball includes the pre-generated file `commit_hash.h` that is required for building
  src = fetchzip {
    url = "https://github.com/ZmnSCPxj/clboss/releases/download/v${version}/clboss-v${version}.tar.gz";
    hash = "sha256-9wrgJzXVBKGSNB2UbP+CnUmaRwdXgRAnHBZbvm/Am7Q=";
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

  meta = with lib; {
    description = "Automated C-Lightning Node Manager";
    homepage = "https://github.com/ZmnSCPxj/clboss";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "clboss";
  };
}
