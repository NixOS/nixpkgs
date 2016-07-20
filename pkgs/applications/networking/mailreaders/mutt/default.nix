{ stdenv, fetchurl, fetchpatch, ncurses, which, perl, autoreconfHook
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gpgme ? null
, aclocal ? null
, headerCache  ? true
, sslSupport   ? true
, saslSupport  ? true
, gpgmeSupport ? true
, imapSupport  ? true
, withSidebar  ? false
, withTrash    ? false
}:

assert headerCache  -> gdbm       != null;
assert sslSupport   -> openssl    != null;
assert saslSupport  -> cyrus_sasl != null;
assert gpgmeSupport -> gpgme      != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mutt-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${name}.tar.gz";
    sha256 = "13hxmji7v9m2agmvzrs7gzx8s3c9jiwrv7pbkr7z1kc6ckq2xl65";
  };

  buildInputs =
    [ ncurses which perl ]
    ++ optional headerCache  gdbm
    ++ optional sslSupport   openssl
    ++ optional saslSupport  cyrus_sasl
    ++ optional gpgmeSupport gpgme
    ++ optional withSidebar  autoreconfHook;

  configureFlags = [
    (enableFeature headerCache  "hcache")
    (enableFeature gpgmeSupport "gpgme")
    (enableFeature imapSupport  "imap")
    (enableFeature withSidebar  "sidebar")
    "--enable-smtp"
    "--enable-pop"
    "--enable-imap"
    "--with-mailpath="

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"

    # This allows calls with "-d N", that output debug info into ~/.muttdebug*
    "--enable-debug"

    # The next allows building mutt without having anything setgid
    # set by the installer, and removing the need for the group 'mail'
    # I set the value 'mailbox' because it is a default in the configure script
    "--with-homespool=mailbox"
  ] ++ optional sslSupport  "--with-ssl"
    ++ optional saslSupport "--with-sasl";

  patches =
    optional withTrash (fetchpatch {
      name = "trash.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/trash.patch?h=mutt-sidebar";
      sha256 = "1hrib9jk28mqd02nzv0sx01jfdabzvnwcc5qjc3810zfglzc1nql";
    }) ++
    optional withSidebar (fetchpatch {
      name = "sidebar.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/sidebar.patch?h=mutt-sidebar";
      sha256 = "1l63wj7kw41jrh00mcxdw4p4vrbc9wld42s99liw8kz2aclymq5m";
    });

  meta = {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny rnhmjoj ];
  };
}
