{ fetchurl, stdenv, jre, glib, libXtst, gtk2, makeWrapper, unzip }:

stdenv.mkDerivation rec {
  pname = "davmail";
  version = "5.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}-3135.zip";
    sha256 = "05n2j5canh046744arvni6yfdsandvjkld93w3p7rg116jrh19gq";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    mkdir -p $out/share/davmail
    cp -vR ./* $out/share/davmail
    makeWrapper $out/share/davmail/davmail $out/bin/davmail \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glib gtk2 libXtst ]}
  '';

  meta = with stdenv.lib; {
    homepage = "http://davmail.sourceforge.net/";
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    maintainers = [ maintainers.hinton ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
