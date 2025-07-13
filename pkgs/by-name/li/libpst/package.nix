{
  lib,
  stdenv,
  fetchurl,
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
    url = "https://www.five-ten-sg.com/libpst/packages/libpst-${finalAttrs.version}.tar.gz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

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

  meta = with lib; {
    homepage = "https://www.five-ten-sg.com/libpst/";
    description = "Library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
