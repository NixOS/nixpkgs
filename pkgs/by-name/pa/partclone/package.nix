{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libuuid,
  e2fsprogs,
  nilfs-utils,
  ntfs3g,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "partclone";
  version = "0.3.38";

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = finalAttrs.version;
    sha256 = "sha256-lWnGi8giz7vzdBnuth55h0VMuNyCQaCclRqPJdm0I14=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    e2fsprogs
    libuuid
    stdenv.cc.libc
    nilfs-utils
    ntfs3g
    openssl
    (lib.getOutput "static" stdenv.cc.libc)
  ];

  configureFlags = [
    "--enable-xfs"
    "--enable-extfs"
    "--enable-hfsp"
    "--enable-fat"
    "--enable-exfat"
    "--enable-ntfs"
    "--enable-btrfs"
    "--enable-minix"
    "--enable-f2fs"
    "--enable-nilfs2"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Utilities to save and restore used blocks on a partition";
    longDescription = ''
      Partclone provides utilities to save and restore used blocks on a
      partition and is designed for higher compatibility of the file system by
      using existing libraries, e.g. e2fslibs is used to read and write the
      ext2 partition.
    '';
    homepage = "https://partclone.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
  };
})
