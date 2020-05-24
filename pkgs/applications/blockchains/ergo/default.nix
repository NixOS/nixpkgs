{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.2.4";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "1xk52b5davd7mz2l35d8vhgff5l8kw6ba0gbnwzkxc8nxmvvsp8b";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/ergo --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "Open protocol that implements modern scientific ideas in the blockchain area";
    homepage    = "https://ergoplatform.org/en/";
    license     = licenses.cc0;
    platforms   = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
