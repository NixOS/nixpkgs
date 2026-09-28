{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook_xml_dtd_45,
  docbook_xsl,
  libtool,
  libxslt,
  pkg-config,
  liburcu,
  libuuid,
  e2fsprogs,
  nilfs-utils,
  ntfs3g,
  openssl,
  xxhash,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "partclone";
  version = "0.3.48";

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = finalAttrs.version;
    hash = "sha256-mN4hIIFBHCawpHq6qGcSmBTsuQk2/gngSgnXMka1HTA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_45
    docbook_xsl
    libtool
    libxslt
    pkg-config
  ];

  postPatch = ''
    substituteInPlace docs/Makefile.am \
      --replace-fail 'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl' \
                     '${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl'
    substituteInPlace docs/*.xml \
      --replace-fail 'http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd' \
                     '${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd'
  '';

  buildInputs = [
    e2fsprogs
    liburcu
    libuuid
    stdenv.cc.libc
    nilfs-utils
    ntfs3g
    openssl
    xxhash
    zlib
    zstd
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
