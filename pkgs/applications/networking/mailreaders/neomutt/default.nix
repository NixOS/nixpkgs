{ stdenv, fetchFromGitHub, which, autoreconfHook, ncurses, perl
, cyrus_sasl, gss, gpgme, kerberos, libidn, notmuch, openssl, lmdb, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  version = "20171013";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = "neomutt-${version}";
    sha256 = "0zn8imqfa76bxpkpy111c4vn6vjarbxc8gqv6m18qkksk0ly26l1";
  };

  nativeBuildInputs = [ autoreconfHook docbook_xsl docbook_xml_dtd_42 libxslt.bin which ];
  buildInputs = [
    cyrus_sasl gss gpgme kerberos libidn ncurses
    notmuch openssl perl lmdb
  ];

  configureFlags = [
    "--enable-debug"
    "--enable-gpgme"
    "--enable-notmuch"
    "--with-homespool=mailbox"
    "--with-gss"
    "--with-mailpath="
    "--with-ssl"
    "--with-sasl"
    "--with-curses"
    "--with-idn"
    "--with-lmdb"

    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"
  ];

  # Fix missing libidn in mutt;
  # this fix is ugly since it links all binaries in mutt against libidn
  # like pgpring, pgpewrap, ...
  NIX_LDFLAGS = "-lidn";

  configureScript = "./prepare";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage    = http://www.neomutt.org;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ cstrahan erikryb jfrankenau vrthra ];
    platforms   = platforms.unix;
  };
}
