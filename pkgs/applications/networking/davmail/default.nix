{ fetchurl, stdenv, jre, glib, libXtst, gtk2, makeWrapper, unzip }:

stdenv.mkDerivation rec {
  name = "davmail-4.8.6";
  src = fetchurl {
    url = "mirror://sourceforge/davmail/4.8.6/davmail-4.8.6-2600.zip";
    sha256 = "1wk4jxb46qlyipxj57flqadgm4mih243rhqq9sp9m5pifjqrw9dp";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    mkdir -p $out/share/davmail
    cp -vR ./* $out/share/davmail
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
