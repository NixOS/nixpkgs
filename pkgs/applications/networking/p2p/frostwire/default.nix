{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.4.5";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "01nq1vwkqdidmprlnz5d3c5412r6igv689barv64dmb9m6iqg53z";
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
