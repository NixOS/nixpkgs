{stdenv, fetchurl, ncurses, which}:

stdenv.mkDerivation {
  name = "mutt-1.5.15";
  src = fetchurl {
    url = ftp://ftp.mutt.org/mutt/devel/mutt-1.5.15.tar.gz;
    sha256 = "03fa1f45d4743cd395b634d19aebbc2c1918cf6b683e0af51076ccc79f643a9a";
  };
  buildInputs = [ ncurses which ];
  configureFlags = "--with-mailpath=/invalid";
}
