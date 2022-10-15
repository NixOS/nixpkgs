{ lib, stdenv, fetchFromGitHub, gettext, makeWrapper, tcl, which
, ncurses, perl , cyrus_sasl, gss, gpgme, libkrb5, libidn, libxml2, notmuch, openssl
, lmdb, libxslt, docbook_xsl, docbook_xml_dtd_42, w3m, mailcap, sqlite, zlib
, zstd, enableZstd ? true, enableMixmaster ? false
}:

stdenv.mkDerivation rec {
  version = "20220429";
  pname = "neomutt";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = version;
    sha256 = "sha256-LBY7WtmEMg/PcMS/Tc5XEYunIWjoI4IQfUJURKgy1YA=";
  };

  buildInputs = [
    cyrus_sasl gss gpgme libkrb5 libidn ncurses
    notmuch openssl perl lmdb
    mailcap sqlite
  ]
  ++ lib.optional enableZstd zstd;

  nativeBuildInputs = [
    docbook_xsl docbook_xml_dtd_42 gettext libxml2 libxslt.bin makeWrapper tcl which zlib w3m
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace auto.def --replace /usr/sbin/sendmail sendmail
    substituteInPlace contrib/smime_keys \
      --replace /usr/bin/openssl ${openssl}/bin/openssl

    for f in doc/*.{xml,xsl}*  ; do
      substituteInPlace $f \
        --replace http://docbook.sourceforge.net/release/xsl/current     ${docbook_xsl}/share/xml/docbook-xsl \
        --replace http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd ${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd
    done


    # allow neomutt to map attachments to their proper mime.types if specified wrongly
    # and use a far more comprehensive list than the one shipped with neomutt
    substituteInPlace send/sendlib.c \
      --replace /etc/mime.types ${mailcap}/etc/mime.types
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  configureFlags = [
    "--enable-autocrypt"
    "--gpgme"
    "--gss"
    "--lmdb"
    "--notmuch"
    "--ssl"
    "--sasl"
    "--with-homespool=mailbox"
    "--with-mailpath="
    # To make it not reference .dev outputs. See:
    # https://github.com/neomutt/neomutt/pull/2367
    "--disable-include-path-in-cflags"
    "--zlib"
  ]
  ++ lib.optional enableZstd "--zstd"
  ++ lib.optional enableMixmaster "--mixmaster";

  # Fix missing libidn in mutt;
  # this fix is ugly since it links all binaries in mutt against libidn
  # like pgpring, pgpewrap, ...
  NIX_LDFLAGS = "-lidn";

  postInstall = ''
    wrapProgram "$out/bin/neomutt" --prefix PATH : "$out/libexec/neomutt"
  '';

  doCheck = true;

  preCheck = ''
    cp -r ${fetchFromGitHub {
      owner = "neomutt";
      repo = "neomutt-test-files";
      rev = "8629adab700a75c54e8e28bf05ad092503a98f75";
      sha256 = "1ci04nqkab9mh60zzm66sd6mhsr6lya8wp92njpbvafc86vvwdlr";
    }} $(pwd)/test-files
    chmod -R +w test-files
    (cd test-files && ./setup.sh)

    export NEOMUTT_TEST_DIR=$(pwd)/test-files
  '';

  checkTarget = "test";
  postCheck = "unset NEOMUTT_TEST_DIR";

  meta = with lib; {
    description = "A small but very powerful text-based mail client";
    homepage    = "http://www.neomutt.org";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ cstrahan erikryb jfrankenau vrthra ma27 raitobezarius ];
    platforms   = platforms.unix;
  };
}
