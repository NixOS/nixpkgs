{ stdenv, fetchFromGitHub, which, autoconf, automake, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl }:

stdenv.mkDerivation rec {
  version = "20160404";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "neomutt";
    rev = "fba0ecd82522c2eacb1aaa70044cae5a77c93acf";
    sha256 = "1blyxb5ga0qf1b5qidg12qhf3dfj1vc6xci0g88xy5zkvkjlhmri";
  };

  buildInputs = with stdenv.lib;
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
    maintainers = with maintainers; [ hiberno ];
  };
}
