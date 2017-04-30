{ fetchurl, stdenv, jre, glib, libXtst, gtk2, makeWrapper }:

stdenv.mkDerivation rec {
  name = "davmail-4.8.0";
  src = fetchurl {
    url = "mirror://sourceforge/davmail/4.8.0/davmail-linux-x86_64-4.8.0-2479.tgz";
    sha256 = "0e650c4a060d64fd2b270ddb00baa906aac617865d5e60c9f526a281cdb27b62";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/davmail
    cp -R ./* $out/share/davmail
    makeWrapper $out/share/davmail/davmail.sh $out/bin/davmail \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glib gtk2 libXtst ]}
  '';

  meta = with stdenv.lib; {
    homepage = http://davmail.sourceforce.net/;
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    maintainers = [ maintainers.hinton ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
