{ stdenv, fetchurl, fetchpatch, ncurses, which, perl
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gnupg ? null
, gpgme ? null
, kerberos ? null
, headerCache  ? true
, sslSupport   ? true
, saslSupport  ? true
, smimeSupport ? false
, gpgSupport   ? false
, gpgmeSupport ? true
, imapSupport  ? true
, withSidebar  ? true
, gssSupport   ? true
}:

assert headerCache  -> gdbm       != null;
assert sslSupport   -> openssl    != null;
assert saslSupport  -> cyrus_sasl != null;
assert smimeSupport -> openssl    != null;
assert gpgSupport   -> gnupg      != null;
assert gpgmeSupport -> gpgme      != null && openssl != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mutt";
  version = "1.13.3";

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${pname}-${version}.tar.gz";
    sha256 = "0y3ks10mc7m8c7pd4c4j8pj7n5rqcvzrjs8mzldv7z7jnlb30hkq";
  };

  patches = [
    # patch for CVE-2020-14093
    (fetchpatch {
      url = "https://github.com/muttmua/mutt/commit/3e88866dc60b5fa6aaba6fd7c1710c12c1c3cd01.patch";
      sha256 = "1md4krh76kjbg6nkyvbpjn6iz17c7m7xvdj6gjvjr7akqjhfw48h";
    })

    # Patch for security issue released in 1.14.4, see
    # https://marc.info/?l=mutt-users&m=159252929418100&w=2
    # and
    # https://marc.info/?l=mutt-users&m=159268982901013&w=2
    (fetchpatch {
      url = "https://github.com/muttmua/mutt/commit/dc909119b3433a84290f0095c0f43a23b98b3748.patch";
      sha256 = "sha256:1qqbl9qd2k1bn6qa5gssb6kqhw275hp2wrz7yhqrp9ijx3nzy281";
    })
  ] ++ optional smimeSupport (fetchpatch {
    url = "https://salsa.debian.org/mutt-team/mutt/raw/debian/1.10.1-2/debian/patches/misc/smime.rc.patch";
    sha256 = "0b4i00chvx6zj9pcb06x2jysmrcb2znn831lcy32cgfds6gr3nsi";
  });

  buildInputs =
    [ ncurses which perl ]
    ++ optional headerCache  gdbm
    ++ optional sslSupport   openssl
    ++ optional gssSupport   kerberos
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
    ++ optional gssSupport  "--with-gss"
    ++ optional saslSupport "--with-sasl";

  postPatch = optionalString (smimeSupport || gpgmeSupport) ''
    sed -i 's#/usr/bin/openssl#${openssl}/bin/openssl#' smime_keys.pl
  '';

  postInstall = optionalString smimeSupport ''
    # S/MIME setup
    cp contrib/smime.rc $out/etc/smime.rc
    sed -i 's#openssl#${openssl}/bin/openssl#' $out/etc/smime.rc
    echo "source $out/etc/smime.rc" >> $out/etc/Muttrc
  '' + optionalString gpgSupport ''
    # GnuPG setup
    cp contrib/gpg.rc $out/etc/gpg.rc
    sed -i 's#\(command="\)gpg #\1${gnupg}/bin/gpg #' $out/etc/gpg.rc
    echo "source $out/etc/gpg.rc" >> $out/etc/Muttrc
  '';

  meta = {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny rnhmjoj ];
  };
}
