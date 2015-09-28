{ stdenv, fetchurl, ncurses, which, perl, autoreconfHook, autoconf, automake, notmuch
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
assert gpgmeSupport -> gpgme != null;

let
  version = "1.5.23.1";
in
stdenv.mkDerivation rec {
  name = "mutt-kz-${version}";

  src = fetchurl {
    url = "https://github.com/karelzak/mutt-kz/archive/v${version}.tar.gz";
    sha256 = "01k4hrf8x2100pcqnrm61mm1x0pqi2kr3rx22k5hwvbs1wh8zyhz";
  };

  buildInputs = with stdenv.lib;
    [ ncurses which perl autoreconfHook autoconf automake notmuch]
    ++ optional headerCache gdbm
    ++ optional sslSupport openssl
    ++ optional saslSupport cyrus_sasl
    ++ optional gpgmeSupport gpgme;

configureFlags = [
    "--with-mailpath=" "--enable-smtp"

    # This allows calls with "-d N", that output debug info into ~/.muttdebug*
    "--enable-debug"

    "--enable-pop" "--enable-imap"

    "--enable-notmuch"

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
    description = "A small but very powerful text-based mail client, forked to support notmuch";
    homepage = https://github.com/karelzak/mutt-kz/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ magnetophon ];
  };
}
