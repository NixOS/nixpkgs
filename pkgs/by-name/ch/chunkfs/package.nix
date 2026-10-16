{
  lib,
  stdenv,
  fetchurl,
  perl,
  fuse3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chunkfs";
  version = "0.8";

  patches = [
    ./fuse3.diff
  ];

  src = fetchurl {
    url = "https://chunkfs.florz.de/chunkfs_${finalAttrs.version}.tar.xz";
    hash = "sha256-HFv51ta2eNW9Qt9CUp2oTTlC8Lpwc1XKR/uYzMDfd88=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    perl
    fuse3
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "FUSE filesystems for viewing chunksync-style directory trees as a block device and vice versa";
    homepage = "http://chunkfs.florz.de";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yayayayaka ];
  };
})
