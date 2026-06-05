{
  lib,
  stdenv,
  fetchurl,
  perl,
  fuse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chunkfs";
  version = "0.8";

  src = fetchurl {
    url = "https://chunkfs.florz.de/chunkfs_${finalAttrs.version}.tar.xz";
    hash = "sha256-HFv51ta2eNW9Qt9CUp2oTTlC8Lpwc1XKR/uYzMDfd88=";
  };

  buildInputs = [
    perl
    fuse
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

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
