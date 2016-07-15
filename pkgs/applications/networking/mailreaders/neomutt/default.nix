{ stdenv, fetchFromGitHub, which, autoconf, automake, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl }:

stdenv.mkDerivation rec {
  version = "20160611";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "neomutt";
    rev = "neomutt-${version}";
    sha256 = "12487hydn9x1yyxzc0x7hssgjwji3i64glmbi7synjc8arfqc5zs";
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
    "--enable-keywords"
    "--enable-smtp"
    "--enable-nntp"
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
    maintainers = with maintainers; [ hiberno cstrahan vrthra ];
  };
}
