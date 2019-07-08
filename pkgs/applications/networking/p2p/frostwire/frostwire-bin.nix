{ stdenv, fetchurl, jre, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.7.4";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "https://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "03vxg0qas4mz5ggrmi396nkz44x1kgq8bfbhbr9mnal9ay9qmi8m";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    mv $(ls */*.jar) $out/share/java

    makeWrapper $out/share/java/frostwire $out/bin/frostwire \
      --prefix PATH : ${jre}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.frostwire.com/;
    description = "BitTorrent Client and Cloud File Downloader";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = platforms.all;
  };
}
