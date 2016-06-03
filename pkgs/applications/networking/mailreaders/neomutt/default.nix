{ stdenv, fetchFromGitHub, which, autoconf, automake, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl }:

stdenv.mkDerivation rec {
  version = "20160502";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "neomutt";
    rev = "neomutt-${version}";
    sha256 = "0r7nn7yjhf3d7nc89gwpgrq45gqiwsrcaw1pkgmvrd16p0jhga1m";
  };

  buildInputs =
    [ autoconf automake cyrus_sasl gdbm gpgme kerberos libidn ncurses
      notmuch which openssl perl ];

  configureFlags = [
    "--enable-debug"
    "--enable-gpgme"
    "--enable-hcache"
    "--enable-imap"
    "--enable-notmuch"
    "--enable-pgp"
    "--enable-pop"
    "--enable-sidebar"
    "--enable-smtp"
    "--with-homespool=mailbox"
    "--with-gss"
    "--with-mailpath="
    "--with-ssl"
    "--with-sasl"
    "--with-curses"
    "--with-regex"
    "--with-idn"

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"
  ];

  configureScript = "./prepare";

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.neomutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hiberno cstrahan ];
  };
}
