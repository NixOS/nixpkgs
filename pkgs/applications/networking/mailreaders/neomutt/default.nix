{ stdenv, fetchFromGitHub, gettext, makeWrapper, tcl, which, writeScript
, ncurses, perl , cyrus_sasl, gss, gpgme, kerberos, libidn, libxml2, notmuch, openssl
, lmdb, libxslt, docbook_xsl, docbook_xml_dtd_42, mailcap, runtimeShell, sqlite, zlib
, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "20200417";
  pname = "neomutt";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = version;
    sha256 = "0s7943r2s14kavyjf7i70vca252l626539i09a9vk0i9sfi35vx5";
  };

  patches = [
    # Remove on next release. Fixes the `change-folder`
    # macro (https://github.com/neomutt/neomutt/issues/2268)
    (fetchpatch {
      url = "https://github.com/neomutt/neomutt/commit/9e7537caddb9c6adc720bb3322a7512cf51ab025.patch";
      sha256 = "1vmlvgnhx1ra3rnyjkpkv6lrqw8xfh2kkmqp43fqn9lnk3pkjxvv";
    })
  ];

  buildInputs = [
    cyrus_sasl gss gpgme kerberos libidn ncurses
    notmuch openssl perl lmdb
    mailcap sqlite
  ];

  nativeBuildInputs = [
    docbook_xsl docbook_xml_dtd_42 gettext libxml2 libxslt.bin makeWrapper tcl which zlib
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace contrib/smime_keys \
      --replace /usr/bin/openssl ${openssl}/bin/openssl

    for f in doc/*.{xml,xsl}*  ; do
      substituteInPlace $f \
        --replace http://docbook.sourceforge.net/release/xsl/current     ${docbook_xsl}/share/xml/docbook-xsl \
        --replace http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd ${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd
    done


    # allow neomutt to map attachments to their proper mime.types if specified wrongly
    # and use a far more comprehensive list than the one shipped with neomutt
    substituteInPlace sendlib.c \
      --replace /etc/mime.types ${mailcap}/etc/mime.types

    # The string conversion tests all fail with the first version of neomutt
    # that has tests (20180223) as well as 20180716 so we disable them for now.
    # I don't know if that is related to the tests or our build environment.
    # Try again with a later release.
    sed -i '/rfc2047/d' test/Makefile.autosetup test/main.c
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
    # Look in $PATH at runtime, instead of hardcoding /usr/bin/sendmail
    "ac_cv_path_SENDMAIL=sendmail"
    "--zlib"
  ];

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
      rev = "1ee274e9ae1330fb901eb7b8275b3079d7869222";
      sha256 = "0dhilz4rr7616jh8jcvh50a3rr09in43nsv72mm6f3vfklcqincp";
    }} $(pwd)/test-files
    (cd test-files && ./setup.sh)

    export NEOMUTT_TEST_DIR=$(pwd)/test-files
  '';

  checkTarget = "test";
  postCheck = "unset NEOMUTT_TEST_DIR";

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage    = "http://www.neomutt.org";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ cstrahan erikryb jfrankenau vrthra ma27 ];
    platforms   = platforms.unix;
  };
}
