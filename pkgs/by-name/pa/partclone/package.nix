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
  versionCheckHook,
  nix-update-script,
  fuse3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "partclone";
  version = "0.3.53";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Thomas-Tsai";
    repo = "partclone";
    rev = finalAttrs.version;
    hash = "sha256-Z60piCqbp3oA3mwCZLhy6GXEvN+Sz1GyPcBWEp1ohvA=";
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
    openssl
    xxhash
    zlib
    zstd
    liburcu
    libuuid

    fuse3
    e2fsprogs
    ntfs3g
    nilfs-utils
  ];

  configureFlags = [
    "--enable-fuse"
    "--enable-xfs"
    "--enable-extfs"
    "--enable-hfsp"
    "--enable-apfs"
    "--enable-fat"
    "--enable-exfat"
    "--enable-ntfs"
    "--enable-btrfs"
    "--enable-minix"
    "--enable-f2fs"
    "--enable-nilfs2"
  ];

  enableParallelBuilding = true;

  # partclone has many executables, however testing one should be enough
  versionCheckProgram = "${placeholder "out"}/bin/partclone.chkimg";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

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
    maintainers = with lib.maintainers; [ daimond113 ];
    platforms = lib.platforms.linux;
  };
})
