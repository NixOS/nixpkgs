{ stdenv, fetchFromGitHub, which, autoreconfHook, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl, lmdb }:

stdenv.mkDerivation rec {
  version = "20170428";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = "neomutt-${version}";
    sha256 = "1p6214agfv9plskkzalh03r5naiiyg1habrnknnjgck3nypb78ik";
  };

  nativeBuildInputs = [ which autoreconfHook ];
  buildInputs =
    [ cyrus_sasl gdbm gpgme kerberos libidn ncurses
      notmuch openssl perl lmdb ];

  configureFlags = [
    "--enable-debug"
    "--enable-gpgme"
    "--enable-hcache"
    "--enable-imap"
    "--enable-notmuch"
    "--enable-pgp"
    "--enable-pop"
    "--enable-sidebar"
    "--enable-keywords"
    "--enable-smtp"
    "--enable-nntp"
    "--enable-compressed"
    "--with-homespool=mailbox"
    "--with-gss"
    "--with-mailpath="
    "--with-ssl"
    "--with-sasl"
    "--with-curses"
    "--with-regex"
    "--with-idn"
    "--with-lmdb"

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"
  ];

  configureScript = "./prepare";

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.neomutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan vrthra erikryb ];
  };
}
