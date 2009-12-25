{ stdenv, fetchurl, ncurses, which, perl
, sslSupport ? true
, imapSupport ? true
, headerCache ? true
, gdbm ? null
, openssl ? null
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "mutt-1.5.20";
  src = fetchurl {
    url = ftp://ftp.mutt.org/mutt/devel/mutt-1.5.20.tar.gz;
    sha256 = "15m7m419r82awx4mr4nam25m0kpg0bs9vw1z4a4mrzvlkl3zqycm";
  };
  buildInputs = [
    ncurses which perl
    (if headerCache then gdbm else null)
    (if sslSupport then openssl else null)
  ];
  configureFlags = [
    "--with-mailpath="
    (if headerCache then "--enable-hcache" else "--disable-hcache")
    (if sslSupport then "--with-ssl" else "--without-ssl")
    (if imapSupport then "--enable-imap" else "--disable-imap")
  ];

  meta = {
    homepage = http://www.mutt.org;
  };
}

