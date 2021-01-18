{ stdenv
, fetchurl
, lib
, mkDerivation
, antiword
, bison
, catdoc
, chmlib
, djvulibre
, file
, gawk
, ghostscript
, gnugrep
, gnused
, gnutar
, groff
, gzip
, libiconv
, libwpd
, libxslt
, lyx
, perl
, pkg-config
, poppler_utils
, python3Packages
, qtbase
, unrtf
, untex
, unzip
, which
, xapian
, zlib
, withGui ? true
}:

assert stdenv.hostPlatform.system != "powerpc-linux";

mkDerivation rec {
  pname = "recoll";
  version = "1.27.12";

  src = fetchurl {
    url = "https://www.lesbonscomptes.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0bgadm8p319fws66ca4rpv9fx2bllbphgn892rh78db81lz20i5v";
  };

  configureFlags = [ "--enable-recollq" "--disable-webkit" ]
    ++ lib.optionals (!withGui) [ "--disable-qtgui" "--disable-x11mon" ]
    ++ (if stdenv.isLinux then [ "--with-inotify" ] else [ "--without-inotify" ]);

  nativeBuildInputs = [ pkg-config ];

  buildInputs = with python3Packages; [
    bison chmlib file python setuptools which xapian zlib
  ] ++ lib.optional withGui qtbase
    ++ lib.optional stdenv.isDarwin libiconv;

  # the filters search through ${PATH} using a sh proc 'checkcmds' for the
  # filtering utils. Short circuit this by replacing the filtering command with
  # the absolute path to the filtering command.
  postInstall = ''
    substituteInPlace $out/lib/*/site-packages/recoll/rclconfig.py --replace /usr/share/recoll $out/share/recoll
    substituteInPlace $out/share/recoll/filters/rclconfig.py       --replace /usr/share/recoll $out/share/recoll
    for f in $out/share/recoll/filters/* ; do
      if [[ ! "$f" =~ \.zip$ ]]; then
        substituteInPlace $f --replace '"antiword"'  '"${lib.getBin antiword}/bin/antiword"'
        substituteInPlace $f --replace '"awk"'       '"${lib.getBin gawk}/bin/awk"'
        substituteInPlace $f --replace '"catppt"'    '"${lib.getBin catdoc}/bin/catppt"'
        substituteInPlace $f --replace '"djvused"'   '"${lib.getBin djvulibre}/bin/djvused"'
        substituteInPlace $f --replace '"djvutxt"'   '"${lib.getBin djvulibre}/bin/djvutxt"'
        substituteInPlace $f --replace '"egrep"'     '"${lib.getBin gnugrep}/bin/egrep"'
        substituteInPlace $f --replace '"groff"'     '"${lib.getBin groff}/bin/groff"'
        substituteInPlace $f --replace '"gunzip"'    '"${lib.getBin gzip}/bin/gunzip"'
        substituteInPlace $f --replace '"iconv"'     '"${lib.getBin libiconv}/bin/iconv"'
        substituteInPlace $f --replace '"pdftotext"' '"${lib.getBin poppler_utils}/bin/pdftotext"'
        substituteInPlace $f --replace '"pstotext"'  '"${lib.getBin ghostscript}/bin/ps2ascii"'
        substituteInPlace $f --replace '"sed"'       '"${lib.getBin gnused}/bin/sed"'
        substituteInPlace $f --replace '"tar"'       '"${lib.getBin gnutar}/bin/tar"'
        substituteInPlace $f --replace '"unzip"'     '"${lib.getBin unzip}/bin/unzip"'
        substituteInPlace $f --replace '"xls2csv"'   '"${lib.getBin catdoc}/bin/xls2csv"'
        substituteInPlace $f --replace '"xsltproc"'  '"${lib.getBin libxslt}/bin/xsltproc"'
        substituteInPlace $f --replace '"unrtf"'     '"${lib.getBin unrtf}/bin/unrtf"'
        substituteInPlace $f --replace '"untex"'     '"${lib.getBin untex}/bin/untex"'
        substituteInPlace $f --replace '"wpd2html"'  '"${lib.getBin libwpd}/bin/wpd2html"'
        substituteInPlace $f --replace /usr/bin/perl   ${lib.getBin perl}/bin/perl
      fi
    done
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace  $f --replace '"lyx"' '"${lib.getBin lyx}/bin/lyx"'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments.
    '';
    homepage = "https://www.lesbonscomptes.com/recoll/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jcumming ];
  };
}
