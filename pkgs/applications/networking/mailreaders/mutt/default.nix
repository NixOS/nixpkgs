{ stdenv, fetchurl, ncurses, which
, sslSupport ? true
, imapSupport ? true
, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "mutt-1.5.15";
  src = fetchurl {
    url = ftp://ftp.mutt.org/mutt/devel/mutt-1.5.15.tar.gz;
    sha256 = "03fa1f45d4743cd395b634d19aebbc2c1918cf6b683e0af51076ccc79f643a9a";
  };
  buildInputs = [
    ncurses which
    (if sslSupport then openssl else null)
  ];
  configureFlags = [
    "--with-mailpath="
    (if sslSupport then "--with-ssl" else "--without-ssl")
    (if imapSupport then "--enable-imap" else "--disable-imap")
  ];
}
