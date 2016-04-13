{ stdenv, fetchurl, ncurses, which, perl, autoreconfHook
, sslSupport ? true
, imapSupport ? true
, headerCache ? true
, saslSupport ? true
, gpgmeSupport ? true
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gpgme ? null
, withSidebar ? false
}:

assert headerCache -> gdbm != null;
assert sslSupport -> openssl != null;
assert saslSupport -> cyrus_sasl != null;
assert gpgmeSupport -> gpgme != null;

let
  version = "1.6.0";
in
stdenv.mkDerivation rec {
  name = "mutt${stdenv.lib.optionalString withSidebar "-with-sidebar"}-${version}";

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/mutt-${version}.tar.gz";
    sha256 = "06bc2drbgalkk68rzg7hq2v5m5qgjxff5357wg0419dpi8ivdbr9";
  };

  buildInputs = with stdenv.lib;
    [ ncurses which perl ]
    ++ optional headerCache gdbm
    ++ optional sslSupport openssl
    ++ optional saslSupport cyrus_sasl
    ++ optional gpgmeSupport gpgme;

  nativeBuildInputs = stdenv.lib.optional withSidebar autoreconfHook;

  configureFlags = [
    "--with-mailpath=" "--enable-smtp"

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"

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

  # Adding the sidebar
  patches = stdenv.lib.optional withSidebar [
    ./trash-folder.patch
    ./sidebar.patch
    ./sidebar-dotpathsep.patch
    ./sidebar-utf8.patch
    ./sidebar-newonly.patch
    ./sidebar-delimnullwide.patch
    ./sidebar-compose.patch
    ./sidebar-new.patch
  ];

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny ];
  };
}
