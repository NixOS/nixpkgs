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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = "squashfuse";
    rev = version;
    sha256 = "sha256-d2mc6bIlprnVV5yCN7WxrE91ZMTSaJtpR0UVEROoYJQ=";
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
