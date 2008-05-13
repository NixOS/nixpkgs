{ stdenv, fetchurl, ncurses, which
, sslSupport ? true
, imapSupport ? true
, headerCache ? true
, gdbm ? null
, openssl ? null
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "mutt-1.5.16";
  src = fetchurl {
    url = ftp://ftp.mutt.org/mutt/devel/mutt-1.5.16.tar.gz;
    sha256 = "825e920b394db6f56fa8deb45977c061331f59d953944e27ff595625bbad3e83";
  };
  buildInputs = [
    ncurses which
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

