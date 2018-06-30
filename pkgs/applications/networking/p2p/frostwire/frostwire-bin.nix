{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.6.7";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "01ah0cwr3ahihfz1xxs0irw4rsa7wjgnlkcqfyg5q9rmzwbnxkyh";
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
