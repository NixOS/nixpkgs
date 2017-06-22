{ stdenv, fetchurl, ncurses, which, perl
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gpgme ? null
, headerCache  ? true
, sslSupport   ? true
, saslSupport  ? true
, gpgmeSupport ? true
, imapSupport  ? true
, withSidebar  ? true
}:

assert headerCache  -> gdbm       != null;
assert sslSupport   -> openssl    != null;
assert saslSupport  -> cyrus_sasl != null;
assert gpgmeSupport -> gpgme      != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mutt-${version}";
  version = "1.8.3";

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${name}.tar.gz";
    sha256 = "0hpd896mw630sd6ps60hpka8cg691nvr627n8kmabv7zcxnp90cv";
  };

  patchPhase = optionalString (openssl != null) ''
    sed -i 's#/usr/bin/openssl#${openssl}/bin/openssl#' smime_keys.pl
  '';

  buildInputs =
    [ ncurses which perl ]
    ++ optional headerCache  gdbm
    ++ optional sslSupport   openssl
    ++ optional saslSupport  cyrus_sasl
    ++ optional gpgmeSupport gpgme;

  configureFlags = [
    (enableFeature headerCache  "hcache")
    (enableFeature gpgmeSupport "gpgme")
    (enableFeature imapSupport  "imap")
    (enableFeature withSidebar  "sidebar")
    "--enable-smtp"
    "--enable-pop"
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

  meta = {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny rnhmjoj ];
  };
}
