{
  lib,
  stdenv,
  nix-update-script,
  testers,
  fetchurl,
  libcddb,
  pkg-config,
  ncurses,
  help2man,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcdio";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/libcdio/libcdio/releases/download/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-b4+99NGJz2Pyp6FUnFFs1yDHsiLHqq28kkom50WkhTk=";
  };

  env = lib.optionalAttrs stdenv.is32bit {
    NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
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
