{ fetchurl, stdenv, jre, glib, libXtst, gtk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "davmail-4.7.2";
  src = fetchurl {
    url = "mirror://sourceforge/davmail/4.7.1/davmail-linux-x86_64-4.7.1-2416.tgz";
    sha256 = "196jr44kksb197biz984z664llf9z3d8rlnjm2iqcmgkjhx1mgy3";
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
  wrapProgram $out/bin/davmail.sh --prefix PATH : ${jre}/bin --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glib gtk libXtst ]}
   '';
}
