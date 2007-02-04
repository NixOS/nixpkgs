{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "nano-2.0.3";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/nano/nano-2.0.3.tar.gz;
    md5 = "b8e2c1450b36d21f9a82509da3e4d9b1";
  };
  buildInputs = [ncurses gettext];
  configureFlags = "--enable-tiny";
}
