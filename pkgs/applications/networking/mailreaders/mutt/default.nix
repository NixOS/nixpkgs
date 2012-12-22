{ stdenv, fetchurl, ncurses, which, perl
, sslSupport ? true
, imapSupport ? true
, headerCache ? true
, saslSupport ? true
, gpgmeSupport ? true
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gpgme ? null
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;
assert saslSupport -> cyrus_sasl != null;

let
  gpgmePatch = fetchurl {
    # Solution for gpgme >= 1.2: http://dev.mutt.org/trac/ticket/3300
    url = "http://dev.mutt.org/trac/raw-attachment/ticket/3300/mutt-1.5.21-gpgme-init.patch";
    sha256 = "1qa1c8gns4q3as1h2lk3x4di2k3hr804ar7xlc6xh9r0zjhzmlk4";
  };
in
stdenv.mkDerivation rec {
  name = "mutt-1.5.21";
  
  src = fetchurl {
    url = "ftp://ftp.mutt.org/mutt/devel/${name}.tar.gz";
    sha256 = "1864cwz240gh0zy56fb47qqzwyf6ghg01037rb4p2kqgimpg6h91";
  };

  patches = [ (if gpgmeSupport then gpgmePatch else null) ];

  buildInputs = [
    ncurses which perl
    (if headerCache then gdbm else null)
    (if sslSupport then openssl else null)
    (if saslSupport then cyrus_sasl else null)
    (if gpgmeSupport then gpgme else null)
  ];
  
  configureFlags = [
    "--with-mailpath=" "--enable-smtp"

    # This allows calls with "-d N", that output debug info into ~/.muttdebug*
    "--enable-debug"

    "--enable-pop" "--enable-imap"

    # The next allows building mutt without having anything setgid
    # set by the installer, and removing the need for the group 'mail'
    # I set the value 'mailbox' because it is a default in the configure script
    "--with-homespool=mailbox"
    (if headerCache then "--enable-hcache" else "--disable-hcache")
    (if sslSupport then "--with-ssl" else "--without-ssl")
    (if imapSupport then "--enable-imap" else "--disable-imap")
    (if saslSupport then "--with-sasl" else "--without-sasl")
    (if gpgmeSupport then "--enable-gpgme" else "--disable-gpgme")
  ];

  meta = {
    homepage = http://www.mutt.org;
  };
}

