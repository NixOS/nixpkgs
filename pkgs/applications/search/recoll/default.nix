{ stdenv, fetchurl
, qt4, xapian, file, python
, djvulibre, groff, libxslt, unzip, xpdf, antiword, catdoc, lyx
, ghostscript, gawk, gnugrep, gnused, gnutar, gzip, libiconv }:

assert stdenv.system != "powerpc-linux";

stdenv.mkDerivation rec {
  ver = "1.20.6";
  name = "recoll-${ver}";

  src = fetchurl {
    url = "http://www.lesbonscomptes.com/recoll/${name}.tar.gz";
    sha256 = "0ympk2w21cxfvysyx96p0npsa54csfc84cicpi8nsj1qp824zxwq";
  };

  configureFlags = [ "--with-inotify" ];

  buildInputs = [ qt4 xapian file python ];

  # the filters search through ${PATH} using a sh proc 'checkcmds' for the
  # filtering utils. Short circuit this by replacing the filtering command with
  # the absolute path to the filtering command. 
  postInstall = ''
    for f in $out/share/recoll/filters/* ; do
      substituteInPlace  $f --replace antiword      ${antiword}/bin/antiword
      substituteInPlace  $f --replace awk           ${gawk}/bin/awk
      substituteInPlace  $f --replace catppt        ${catdoc}/bin/catppt
      substituteInPlace  $f --replace djvused       ${djvulibre}/bin/djvused
      substituteInPlace  $f --replace djvutxt       ${djvulibre}/bin/djvutxt
      substituteInPlace  $f --replace grep          ${gnugrep}/bin/grep
      substituteInPlace  $f --replace groff         ${groff}/bin/groff
      substituteInPlace  $f --replace gunzip        ${gzip}/bin/gunzip
      substituteInPlace  $f --replace iconv         ${libiconv}/bin/iconv
      substituteInPlace  $f --replace lyx           ${lyx}/bin/lyx
      substituteInPlace  $f --replace pdftotext     ${xpdf}/bin/pdftotext
      substituteInPlace  $f --replace pstotext      ${ghostscript}/bin/ps2ascii 
      substituteInPlace  $f --replace sed           ${gnused}/bin/sed
      substituteInPlace  $f --replace tar           ${gnutar}/bin/tar
      substituteInPlace  $f --replace unzip         ${unzip}/bin/unzip
      substituteInPlace  $f --replace xls2csv       ${catdoc}/bin/xls2csv
      substituteInPlace  $f --replace xsltproc      ${libxslt}/bin/xsltproc
    done
  '';
    # TODO:
    #substituteInPlace  $f --replace unrtf         ${unrtf}/bin/unrtf 
    #substituteInPlace  $f --replace untex         ${untex}/bin/untex
    #substituteInPlace  $f --replace wpd2html      ${wpd2html}/bin/wpd2html

  meta = with stdenv.lib; {
    description = "A full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments. 
    '';
    homepage = http://www.lesbonscomptes.com/recoll/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jcumming ];
  };
}
