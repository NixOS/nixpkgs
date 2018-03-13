{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.6.3";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "0n1g0am3d2fxw4a4zzzyif1fal1x3xch9q7743jhkkm3mldl2grw";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    mv $(ls */*.jar) $out/share/java

    makeWrapper $out/share/java/frostwire $out/bin/frostwire \
      --prefix PATH : ${jre}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.frostwire.com/;
    description = "BitTorrent Client and Cloud File Downloader";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = platforms.all;
  };
}
