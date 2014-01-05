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
  version = "1.5.22";
in
stdenv.mkDerivation rec {
  name = "mutt-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.mutt.org/mutt/devel/${name}.tar.gz";
    sha256 = "19zk81spnb0gc8y5mwmcfn33g77wv1xz5bmgic8aan07xn8fislg";
  };

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

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = "GPLv2+";
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny ];
  };
}

