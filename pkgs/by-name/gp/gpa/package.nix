{
  lib,
  stdenv,
  fetchurl,
  intltool,
  pkg-config,
  gtk3,
  gpgme,
  libgpg-error,
  libassuan,
}:

stdenv.mkDerivation rec {
  pname = "gpa";
  version = "0.11.0";

  src = fetchurl {
    url = "mirror://gnupg/gpa/gpa-${version}.tar.bz2";
    hash = "sha256-Jqj6W/cFQct0Hwxxt8/ikbHqVuq2jusHqpYs71zfM8w=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
    gpgme
    libgpg-error
    libassuan
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  meta = {
    changelog = "https://dev.gnupg.org/source/gpa/browse/master/NEWS;gpa-${version}?view=raw";
    description = "Graphical user interface for the GnuPG";
    homepage = "https://www.gnupg.org/related_software/gpa/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gpa";
  };
}
