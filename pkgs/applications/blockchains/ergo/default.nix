{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "5.0.13";

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "sha256-ZnWiP6Mk6EnrqPT+apSQ0igIEVHy+B8QVbsXRna7up0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/ergo --add-flags "-jar $src"
  '';

  meta = with lib; {
    description = "Open protocol that implements modern scientific ideas in the blockchain area";
    homepage = "https://ergoplatform.org/en/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
