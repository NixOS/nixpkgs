{
  lib,
  stdenv,
  fetchzip,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  curlWithGnuTls,
  libev,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "clboss";
  version = "0.14.0";

  # The release tarball includes the pre-generated file `commit_hash.h` that is required for building
  src = fetchzip {
    url = "https://github.com/ZmnSCPxj/clboss/releases/download/v${version}/clboss-v${version}.tar.gz";
    hash = "sha256-Qp8br4ZxiqaxFZ6Tb+wFpqp2APmnU9QdNkM8MyGAtrw=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    libev
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
