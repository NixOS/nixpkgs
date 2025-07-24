{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  testers,
  texinfo,
  libcddb,
  pkg-config,
  ncurses,
  help2man,
  libiconv,
  withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcdio";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libcdio";
    repo = "libcdio";
    tag = finalAttrs.version;
    hash = "sha256-izjZk2kz9PkLm9+INUdl1e7jMz3nUsQKdplKI9Io+CM=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.is32bit {
    NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
  };

  postPatch = ''
    patchShebangs .
    echo "
    @set UPDATED 1 January 1970
    @set UPDATED-MONTH January 1970
    @set EDITION ${finalAttrs.version}
    @set VERSION ${finalAttrs.version}
    " > doc/version.texi
  ''
  + lib.optionalString (!withMan) ''
    substituteInPlace src/Makefile.am \
      --replace-fail 'man_cd_drive     = cd-drive.1' "" \
      --replace-fail 'man_cd_info     = cd-info.1' "" \
      --replace-fail 'man_cd_read     = cd-read.1' "" \
      --replace-fail 'man_iso_info     = iso-info.1' "" \
      --replace-fail 'man_iso_read     = iso-read.1' ""
  '';

  configureFlags = [
    (lib.enableFeature withMan "maintainer-mode")
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    texinfo
  ]
  ++ lib.optionals withMan [
    help2man
  ];

  buildInputs = [
    libcddb
    libiconv
    ncurses
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  outputs = [
    "out"
    "lib"
    "dev"
    "info"
  ]
  ++ lib.optionals withMan [
    "man"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = "https://www.gnu.org/software/libcdio/";
    license = lib.licenses.gpl2Plus;
    pkgConfigModules = [
      "libcdio"
      "libcdio++"
      "libiso9660"
      "libiso9660++"
      "libudf"
    ];
    platforms = lib.platforms.unix;
  };
})
