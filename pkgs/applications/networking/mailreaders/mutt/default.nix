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
  version = "1.5.23";
in
stdenv.mkDerivation rec {
  name = "mutt${stdenv.lib.optionalString withSidebar "-with-sidebar"}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mutt/mutt-${version}.tar.gz";
    sha256 = "0dzx4qk50pjfsb6cs5jahng96a52k12f7pm0sc78iqdrawg71w1s";
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
  patches = [] ++
    (stdenv.lib.optional withSidebar (fetchurl {
      url = http://lunar-linux.org/~tchan/mutt/patch-1.5.23.sidebar.20140412.txt;
      sha256 = "1i2r7dj0pd1k0z3jjxn2szi6sf0k28i8dwhr4f65pn8r2lh3wisz";
    }));

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny ];
  };
}
