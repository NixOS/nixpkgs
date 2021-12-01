{ fetchurl, lib, stdenv, jre, glib, libXtst, gtk2, makeWrapper, unzip }:

stdenv.mkDerivation rec {
  pname = "davmail";
  version = "5.5.1";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}-3299.zip";
    sha256 = "sha256-NN/TUOcUIifNzrJnZmtYhs6UVktjlfoOYJjYaMEQpI4=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/davmail
    cp -vR ./* $out/share/davmail
    makeWrapper $out/share/davmail/davmail $out/bin/davmail \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gtk2 libXtst ]}
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://davmail.sourceforge.net/";
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    maintainers = [ maintainers.hinton ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
