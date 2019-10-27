{ fetchurl, stdenv, jre, glib, libXtst, gtk2, makeWrapper, unzip }:

stdenv.mkDerivation rec {
  pname = "davmail";
  version = "5.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}-2961.zip";
    sha256 = "0jw6sjg7k7zg8ab0srz6cjjj5hnw5ppxx1w35sw055dlg54fh2m5";
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
    homepage = http://davmail.sourceforge.net/;
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    maintainers = [ maintainers.hinton ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
