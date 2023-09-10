{ lib, stdenv, fetchurl, fetchpatch, ncurses, which, perl
, gdbm ? null
, openssl ? null
, cyrus_sasl ? null
, gnupg ? null
, gpgme ? null
, libkrb5 ? null
, headerCache  ? true
, sslSupport   ? true
, saslSupport  ? true
, smimeSupport ? false
, gpgSupport   ? false
, gpgmeSupport ? true
, imapSupport  ? true
, pop3Support  ? true
, smtpSupport  ? true
, withSidebar  ? true
, gssSupport   ? true
, writeScript
}:
assert smimeSupport -> sslSupport;
assert gpgmeSupport -> sslSupport;

stdenv.mkDerivation rec {
  pname = "mutt";
  version = "2.2.12";
  outputs = [ "out" "doc" "info" ];

  src = fetchurl {
    url = "http://ftp.mutt.org/pub/mutt/${pname}-${version}.tar.gz";
    hash = "sha256-BDrzEvZLjlb3/Qv3f4SiBdTEmAML2VhkV2ZcR7sYzjg=";
  };

  patches = [
    # Avoid build-only references embedding into 'mutt -v' output.
    ./no-build-only-refs.patch
  ] ++ lib.optional smimeSupport (fetchpatch {
    url = "https://salsa.debian.org/mutt-team/mutt/raw/debian/1.10.1-2/debian/patches/misc/smime.rc.patch";
    sha256 = "0b4i00chvx6zj9pcb06x2jysmrcb2znn831lcy32cgfds6gr3nsi";
  });

  buildInputs =
    [ ncurses which perl ]
    ++ lib.optional headerCache  gdbm
    ++ lib.optional sslSupport   openssl
    ++ lib.optional gssSupport   libkrb5
    ++ lib.optional saslSupport  cyrus_sasl
    ++ lib.optional gpgmeSupport gpgme;

  configureFlags = [
    (lib.enableFeature headerCache  "hcache")
    (lib.enableFeature gpgmeSupport "gpgme")
    (lib.enableFeature imapSupport  "imap")
    (lib.enableFeature smtpSupport  "smtp")
    (lib.enableFeature pop3Support  "pop")
    (lib.enableFeature withSidebar  "sidebar")
    "--with-mailpath="

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"

    # This allows calls with "-d N", that output debug info into ~/.muttdebug*
    "--enable-debug"

    # The next allows building mutt without having anything setgid
    # set by the installer, and removing the need for the group 'mail'
    # I set the value 'mailbox' because it is a default in the configure script
    "--with-homespool=mailbox"
  ] ++ lib.optional sslSupport  "--with-ssl"
    ++ lib.optional gssSupport  "--with-gss"
    ++ lib.optional saslSupport "--with-sasl";

  postPatch = lib.optionalString (smimeSupport || gpgmeSupport) ''
    sed -i 's#/usr/bin/openssl#${openssl}/bin/openssl#' smime_keys.pl
  '';

  postInstall = lib.optionalString smimeSupport ''
    # S/MIME setup
    cp contrib/smime.rc $out/etc/smime.rc
    sed -i 's#openssl#${openssl}/bin/openssl#' $out/etc/smime.rc
    echo "source $out/etc/smime.rc" >> $out/etc/Muttrc
  '' + lib.optionalString gpgSupport ''
    # GnuPG setup
    cp contrib/gpg.rc $out/etc/gpg.rc
    sed -i 's#\(command="\)gpg #\1${gnupg}/bin/gpg #' $out/etc/gpg.rc
    echo "source $out/etc/gpg.rc" >> $out/etc/Muttrc
  '';

  passthru = {
    updateScript = writeScript "update-mutt" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -euo pipefail

      # Expect the text in format of "The current stable public release version is 2.2.6."
      new_version="$(curl -s http://www.mutt.org/download.html |
          pcregrep -o1 'The current stable public release version is ([0-9.]+).')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    description = "A small but very powerful text-based mail client";
    homepage = "http://www.mutt.org";
    mainProgram = "mutt";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
