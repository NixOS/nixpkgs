{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "nano-2.0.2";
  src = fetchurl {
    url = ftp://ftp.nano-editor.org/pub/nano/v2.0/nano-2.0.2.tar.gz;
    md5 = "38046476096530e19a7e805513c64108";
  };
  buildInputs = [ncurses gettext];
  configureFlags = "--enable-tiny";
}
