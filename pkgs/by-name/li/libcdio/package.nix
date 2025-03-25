{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  texinfo,
  libcddb,
  pkg-config,
  ncurses,
  help2man,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "libcdio";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libcdio";
    repo = "libcdio";
    tag = version;
    hash = "sha256-izjZk2kz9PkLm9+INUdl1e7jMz3nUsQKdplKI9Io+CM=";
  };

  env = lib.optionalAttrs stdenv.is32bit {
    NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
  };

  postPatch = ''
    patchShebangs .
    echo "
    @set UPDATED 1 January 1970
    @set UPDATED-MONTH January 1970
    @set EDITION ${version}
    @set VERSION ${version}
    " > doc/version.texi
  '';

  configureFlags = [
    (lib.enableFeature true "maintainer-mode")
  ];

  nativeBuildInputs = [
    pkg-config
    help2man
    autoreconfHook
    texinfo
  ];

  buildInputs = [
    libcddb
    libiconv
    ncurses
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = "https://www.gnu.org/software/libcdio/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
