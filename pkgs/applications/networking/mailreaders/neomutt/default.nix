{ stdenv, fetchFromGitHub, which, autoreconfHook, ncurses, perl
, cyrus_sasl, gdbm, gpgme, kerberos, libidn, notmuch, openssl, lmdb, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  version = "20170602";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = "neomutt-${version}";
    sha256 = "0rpvxmv10ypl7la4nmp0s02ixmm9g5pn9g9ms8ygzsix9pa86w45";
  };

  nativeBuildInputs = [ autoreconfHook docbook_xsl libxslt.bin which ];
  buildInputs = [
    cyrus_sasl gdbm gpgme kerberos libidn ncurses
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.neomutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan vrthra erikryb ];
  };
}
