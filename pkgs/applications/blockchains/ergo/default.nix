{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.3.5";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "0bxzpwwb42bppqli3zggx3lah7g6kwmy6k6k6dinypj6x0bafqcg";
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
