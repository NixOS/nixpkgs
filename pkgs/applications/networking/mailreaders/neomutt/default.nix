{ stdenv, fetchFromGitHub, which, makeWrapper, writeScript, gettext,
ncurses, perl , cyrus_sasl, gss, gpgme, kerberos, libidn, notmuch, openssl,
lmdb, libxslt, docbook_xsl, docbook_xml_dtd_42, mime-types
, nullmailer ? null
, withLua ? false, lua52Packages
}:

let
  muttWrapper = writeScript "mutt" ''
    #!${stdenv.shell} -eu

    echo 'The neomutt project has renamed the main binary from `mutt` to `neomutt`.'
    echo ""
    echo 'This wrapper is provided for compatibility purposes only. You should start calling `neomutt` instead.'
    echo ""
    read -p 'Press any key to launch NeoMutt...' -n1 -s
    exec neomutt "$@"
  '';

in stdenv.mkDerivation rec {
  version = "20171215";
  name = "neomutt-${version}";

  src = fetchFromGitHub {
    owner  = "neomutt";
    repo   = "neomutt";
    rev    = "neomutt-${version}";
    sha256 = "1c7vjl5cl0k41vrxp6l1sj72idz70r2rgaxa2m1yir6zb6qsrsd8";
  };

  buildInputs = [
    cyrus_sasl gss gpgme kerberos libidn ncurses
    notmuch openssl perl lmdb gettext
    mime-types
    nullmailer # default to null, so its optional.
  ] ++ stdenv.lib.optional withLua [ lua52Packages.lua ];


  nativeBuildInputs = [
    docbook_xsl docbook_xml_dtd_42 libxslt.bin which makeWrapper
  ];

  enableParallelBuilding = true;

  postPatch = ''
    for f in doc/*.{xml,xsl}*  ; do
      substituteInPlace $f \
        --replace http://docbook.sourceforge.net/release/xsl/current     ${docbook_xsl}/share/xml/docbook-xsl \
        --replace http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd ${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd
    done

    # allow neomutt to map attachments to their proper mime.types if specified wrongly
    # and use a far more comprehensive list than the one shipped with neomutt
    substituteInPlace sendlib.c \
      --replace /etc/mime.types ${mime-types}/etc/mime.types
  '';

  configureFlags = [
    "--with-ui=ncurses"
    "--debug"
    "--gss"
    "--idn"
    "--gpgme"
    "--homespool=1"
    "--with-homespool=mailbox"
    "--ssl"
    "--sasl"
    "--notmuch"
    "--lmdb"
  ] ++ stdenv.lib.optional withLua ["--lua" "--with-lua=${lua52Packages.lua}" ];

  # Fix missing libidn in mutt;
  # this fix is ugly since it links all binaries in mutt against libidn
  # like pgpring, pgpewrap, ...
  NIX_LDFLAGS = "-lidn";

  configureScript = "./configure";

  postInstall = ''
    cp ${muttWrapper} $out/bin/mutt
    wrapProgram "$out/bin/neomutt" --prefix PATH : "$out/lib/neomutt"
  '';

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage    = http://www.neomutt.org;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ cstrahan erikryb jfrankenau vrthra ];
    platforms   = platforms.unix;
  };
}

