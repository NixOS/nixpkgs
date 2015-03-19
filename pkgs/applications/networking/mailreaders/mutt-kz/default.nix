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
#, withSidebar ? false
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;
assert saslSupport -> cyrus_sasl != null;
assert gpgmeSupport -> gpgme != null;

let
  version = "1.5.23.1-rc1";
in
stdenv.mkDerivation rec {
  name = "mutt-kz-${version}";

  src = fetchurl {
    url = "https://github.com/karelzak/mutt-kz/archive/v${version}.tar.gz";
    sha256 = "1m4bnn8psyrx2wy8ribannmp5qf75lv1gz116plji2z37z015zny";
  };

  buildInputs = with stdenv.lib;
    [ ncurses which perl autoreconfHook autoconf automake notmuch]
    ++ optional headerCache gdbm
    ++ optional sslSupport openssl
    ++ optional saslSupport cyrus_sasl
    ++ optional gpgmeSupport gpgme;

#  nativeBuildInputs = stdenv.lib.optional withSidebar autoreconfHook;


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

  # Adding the sidebar
  /*patches = [] ++*/
    /*(stdenv.lib.optional withSidebar (fetchurl {*/
      /*url = http://lunar-linux.org/~tchan/mutt/patch-1.5.23.sidebar.20140412.txt;*/
      /*sha256 = "1i2r7dj0pd1k0z3jjxn2szi6sf0k28i8dwhr4f65pn8r2lh3wisz";*/
    /*}));*/

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client, forked to support notmuch";
    homepage = https://github.com/karelzak/mutt-kz/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ magnetophon ];
  };
}
