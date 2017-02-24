{ stdenv, fetchFromGitHub, which, autoconf, automake, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl }:

stdenv.mkDerivation rec {
  version = "20160827";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "neomutt";
    rev = "neomutt-${version}";
    sha256 = "1gam2iyy75drlp9ap1hlfb38i0p6zwgw09m08m5x50dbp3lxf7xp";
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
