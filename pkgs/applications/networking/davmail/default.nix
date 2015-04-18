{ fetchurl, stdenv, jre, glib, libXtst, gtk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "davmail-4.6.1";
  src = fetchurl {
    url = "mirror://sourceforge/davmail/davmail-linux-x86_64-4.6.1-2343.tgz";
    sha256 = "15kpbrmw9pcifxj4k4m3q0azbl95kfgwvgb8bc9aj00q0yi3wgiq";
  };

  buildInputs = [ makeWrapper ];

  meta = {
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    maintainers = [ stdenv.lib.maintainers.hinton ];
    platforms = stdenv.lib.platforms.all;
    homepage = "http://davmail.sourceforce.net/";
    license = stdenv.lib.licenses.gpl2;
  };

  installPhase = ''
  mkdir -p $out/bin
  cp ./* $out/bin/ -R
  wrapProgram $out/bin/davmail.sh --prefix PATH : ${jre}/bin --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib
   '';
}
