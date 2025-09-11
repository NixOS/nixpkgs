{
  stdenv,
  lib,
  fetchurl,
  bzip2,
  curl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cfitsio";
  version = "4.4.1";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZqHcPyGAD57qvZ6sV3uR/N2aq7pnj7ujuFJzGRENHSU=";
  };

  patches = [
    ./darwin-rpath-universal.patch
  ];

  buildInputs = [
    bzip2
    curl
    zlib
  ];

  configureFlags = [
    "--with-bzip2=${bzip2.out}"
    "--enable-reentrant"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    # concerning. upstream defines XOPEN_SOURCE=700 which makes FreeBSD very insistent on
    # not showing us gethostbyname()
    NIX_CFLAGS_COMPILE = "-D__BSD_VISIBLE=1";
  };

  hardeningDisable = [ "format" ];

  # Shared-only build
  buildFlags = [ "shared" ];

  postPatch = ''
    sed -e '/^install:/s/libcfitsio.a //' -e 's@/bin/@@g' -i Makefile.in
  '';

  meta = {
    homepage = "https://heasarc.gsfc.nasa.gov/fitsio/";
    description = "Library for reading and writing FITS data files";
    longDescription = ''
      CFITSIO is a library of C and Fortran subroutines for reading and
      writing data files in FITS (Flexible Image Transport System) data
      format.  CFITSIO provides simple high-level routines for reading and
      writing FITS files that insulate the programmer from the internal
      complexities of the FITS format.  CFITSIO also provides many
      advanced features for manipulating and filtering the information in
      FITS files.
    '';
    changelog = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/docs/changes.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      returntoreality
      xbreak
      hjones2199
    ];
    platforms = lib.platforms.unix;
  };
})
