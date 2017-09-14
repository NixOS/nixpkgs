{ stdenv, fetchFromGitHub, which, autoreconfHook, ncurses, perl
, cyrus_sasl, gss, gpgme, kerberos, libidn, notmuch, openssl, lmdb, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  version = "20170912";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = "neomutt-${version}";
    sha256 = "0qndszmaihly3pp2wqiqm31nxbv9ys3j05kzffaqhzngfilmar9g";
  };

  nativeBuildInputs = [ autoreconfHook docbook_xsl libxslt.bin which ];
  buildInputs = [
    cyrus_sasl gss gpgme kerberos libidn ncurses
    notmuch openssl perl lmdb
  ];

  postPatch = ''
    for f in doc/*.xsl ; do
      substituteInPlace $f \
        --replace http://docbook.sourceforge.net/release/xsl/current ${docbook_xsl}/share/xml/docbook-xsl
    done
  '';

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
