{ stdenv, fetchurl, ncurses, which, perl
, sslSupport ? true
, imapSupport ? true
, headerCache ? true
, saslSupport ? true
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;
assert saslSupport -> cyrus_sasl != null;

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
    (if saslSupport then cyrus_sasl else null)
  ];
  configureFlags = [
    "--with-mailpath=" "--enable-smtp"
    # The next allows building mutt without having anything setgid
    # set by the installer, and removing the need for the group 'mail'
    # I set the value 'mailbox' because it is a default in the configure script
    "--with-homespool=mailbox"
    (if headerCache then "--enable-hcache" else "--disable-hcache")
    (if sslSupport then "--with-ssl" else "--without-ssl")
    (if imapSupport then "--enable-imap" else "--disable-imap")
    (if saslSupport then "--with-sasl" else "--without-imap")
  ];

  meta = {
    homepage = http://www.mutt.org;
  };
}

