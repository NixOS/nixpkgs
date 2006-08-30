{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "nano-1.2.5";
  src = fetchurl {
    url = http://www.nano-editor.org/dist/v1.2/nano-1.2.5.tar.gz;
    md5 = "f2b3efbf1cf356d736740d531b6b22c4";
  };
  buildInputs = [ncurses gettext];
  configureFlags = "--enable-tiny";
}
