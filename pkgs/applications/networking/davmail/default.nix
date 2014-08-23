{ fetchurl, stdenv, jre, glib, libXtst, gtk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "davmail-4.5.0";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/davmail/davmail/4.5.0/davmail-linux-x86_64-4.5.0-2292.tgz";
    sha256 = "0ixg26s8535b4xf4i8jr0v3acwvaslmi2dvcxg2nmzkicvh6rfd4";
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
