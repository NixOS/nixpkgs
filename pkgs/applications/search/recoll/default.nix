{ stdenv, fetchurl, lib, bison
, qt4, xapian, file, python, perl
, djvulibre, groff, libxslt, unzip, poppler_utils, antiword, catdoc, lyx
, libwpd, unrtf, untex
, ghostscript, gawk, gnugrep, gnused, gnutar, gzip, libiconv }:

assert stdenv.system != "powerpc-linux";

stdenv.mkDerivation rec {
  ver = "1.23.1";
  name = "recoll-${ver}";

  src = fetchurl {
    url = "http://www.lesbonscomptes.com/recoll/${name}.tar.gz";
    sha256 = "0si407qm47ndy0l6zv57lqb5za4aiv0lyghnzb211g03szjkfpg8";
  };

  configureFlags = [ "--with-inotify" ];

  buildInputs = [ qt4 xapian file python bison];

  # the filters search through ${PATH} using a sh proc 'checkcmds' for the
  # filtering utils. Short circuit this by replacing the filtering command with
  # the absolute path to the filtering command. 
  postInstall = ''
    for f in $out/share/recoll/filters/* ; do
      substituteInPlace  $f --replace antiword      ${lib.getBin antiword}/bin/antiword
      substituteInPlace  $f --replace awk           ${lib.getBin gawk}/bin/awk
      substituteInPlace  $f --replace catppt        ${lib.getBin catdoc}/bin/catppt
      substituteInPlace  $f --replace djvused       ${lib.getBin djvulibre}/bin/djvused
      substituteInPlace  $f --replace djvutxt       ${lib.getBin djvulibre}/bin/djvutxt
      substituteInPlace  $f --replace egrep         ${lib.getBin gnugrep}/bin/egrep
      substituteInPlace  $f --replace groff         ${lib.getBin groff}/bin/groff
      substituteInPlace  $f --replace gunzip        ${lib.getBin gzip}/bin/gunzip
      substituteInPlace  $f --replace iconv         ${lib.getBin libiconv}/bin/iconv
      substituteInPlace  $f --replace lyx           ${lib.getBin lyx}/bin/lyx
      substituteInPlace  $f --replace pdftotext     ${lib.getBin poppler_utils}/bin/pdftotext
      substituteInPlace  $f --replace pstotext      ${lib.getBin ghostscript}/bin/ps2ascii
      substituteInPlace  $f --replace sed           ${lib.getBin gnused}/bin/sed
      substituteInPlace  $f --replace tar           ${lib.getBin gnutar}/bin/tar
      substituteInPlace  $f --replace unzip         ${lib.getBin unzip}/bin/unzip
      substituteInPlace  $f --replace xls2csv       ${lib.getBin catdoc}/bin/xls2csv
      substituteInPlace  $f --replace xsltproc      ${lib.getBin libxslt}/bin/xsltproc
      substituteInPlace  $f --replace unrtf         ${lib.getBin unrtf}/bin/unrtf
      substituteInPlace  $f --replace untex         ${lib.getBin untex}/bin/untex
      substituteInPlace  $f --replace wpd2html      ${lib.getBin libwpd}/bin/wpd2html
      substituteInPlace  $f --replace /usr/bin/perl ${lib.getBin perl}/bin/perl
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments. 
    '';
    homepage = http://www.lesbonscomptes.com/recoll/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jcumming ];
  };
}
