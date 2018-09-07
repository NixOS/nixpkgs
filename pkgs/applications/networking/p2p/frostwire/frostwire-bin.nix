{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.7.2";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "https://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "1dxk2cmwbn4ahkmr8qpiq1dpkkyswg5wz1cnv36izafpr87lxfvj";
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
