{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  fuse,
  curl,
  pkg-config,
  glib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "curlftpfs";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/curlftpfs/curlftpfs-${version}.tar.gz";
    sha256 = "0n397hmv21jsr1j7zx3m21i7ryscdhkdsyqpvvns12q7qwwlgd2f";
  };

  patches = [
    # This removes AC_FUNC_MALLOC and AC_FUNC_REALLOC from configure.ac because
    # it is known to cause problems. Search online for "rpl_malloc" and
    # "rpl_realloc" to find out more.
    ./fix-rpl_malloc.patch
    ./suse-bug-580609.patch
    ./suse-bug-955687.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    fuse
    curl
    glib
    zlib
  ];

  CFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-D__off_t=off_t";

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix the build on macOS with macFUSE installed. Needs autoreconfHook for
    # this change to effect
    substituteInPlace configure.ac --replace \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' \
      ""
  '';

  doCheck = false; # fails, doesn't work well too, btw

  meta = with lib; {
    description = "Filesystem for accessing FTP hosts based on FUSE and libcurl";
    mainProgram = "curlftpfs";
    homepage = "https://curlftpfs.sourceforge.net";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
