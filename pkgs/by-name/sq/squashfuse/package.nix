{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  fuse,
  pkg-config,
  lz4,
  xz,
  zlib,
  lzo,
  zstd,
}:

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = version;
    sha256 = "sha256-76PQB+6ls/RCjEP8Z4DEtX0xemN3srCsLM7DsDqiTVA=";
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
    fuse
  ];

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = "BSD-2-Clause";
  };
}
