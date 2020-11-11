{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.3.6";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "1zi559ixjxxsrpvvjbxa1d0g96px3h9amjvy149sfhp7b8w5hhk3";
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
