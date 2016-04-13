{ fetchurl, stdenv, jre, glib, libXtst, gtk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "davmail-4.7.1";
  src = fetchurl {
    url = "mirror://sourceforge/davmail/4.7.1/davmail-linux-x86_64-4.7.1-2416.tgz";
    sha256 = "c3bf1a3a94f35586a3a8d2d28cdaf8c9514a8cf904a51fd74961e93909c9d2a4";
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
