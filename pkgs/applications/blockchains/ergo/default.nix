{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.3.3";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "1lsqshpbc5p5qm8kic8a90xmvd2zx2s7jf613j9ng4h3hh75wbff";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/ergo --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "Open protocol that implements modern scientific ideas in the blockchain area";
    homepage = "https://ergoplatform.org/en/";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
