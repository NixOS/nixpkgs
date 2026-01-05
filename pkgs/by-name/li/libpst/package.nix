{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  bzip2,
  doxygen,
  gettext,
  imagemagick,
  libgsf,
  pkg-config,
  xmlto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpst";
  version = "0.6.76";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/libpst-${finalAttrs.version}.tar.gz";
    hash = "sha256-PSkb7rvbSNK5NGCLwGGVtkHaY9Ko9eDThvLp1tBaC0I=";
  };

  patches = [
    # readpst: Fix a build with gcc/C23 standard
    (fetchpatch {
      url = "https://github.com/pst-format/libpst/commit/cc600ee98c4ed23b8ab0bc2cf6b6c6e9cb587e89.patch";
      hash = "sha256-lD6vJrRbqnlG69+aU0v32UTxD0NfKNr6vPcysXK7ir0=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    gettext
    pkg-config
    xmlto
  ];

  buildInputs = [
    bzip2
    imagemagick
    libgsf
  ];

  configureFlags = [
    "--disable-static"
    "--enable-libpst-shared"
    "--enable-python=no"
  ];

  doCheck = true;

  meta = {
    homepage = "https://www.five-ten-sg.com/libpst/";
    description = "Library to read PST (MS Outlook Personal Folders) files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
