{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  fuse3,
  pkg-config,
  lz4,
  xz,
  zlib,
  lzo,
  zstd,
}:

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = "squashfuse";
    rev = version;
    sha256 = "sha256-HuDVCO+hKdUKz0TMfHquI0eqFNAoNhPfY2VBM2kXupk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];
  buildInputs = [
    lz4
    xz
    zlib
    lzo
    zstd
    fuse3
  ];

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = "BSD-2-Clause";
  };
}
