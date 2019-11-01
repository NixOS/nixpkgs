{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.8.3";
  pname = "frostwire";

  src = fetchurl {
    url = "https://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "00r7rxzk9a7a1sc0shdx7fq9p9dzg5pwfdf8day0kr1844a5arc2";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    mv $(ls */*.jar) $out/share/java

    makeWrapper $out/share/java/frostwire $out/bin/frostwire \
      --prefix PATH : ${jre}/bin/ \
      --set JAVA_HOME ${jre.home} \
      --add-flags '-classpath $CLASSPATH:$out/share/java/*'
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.frostwire.com/";
    description = "BitTorrent Client and Cloud File Downloader";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = platforms.all;
  };
}
