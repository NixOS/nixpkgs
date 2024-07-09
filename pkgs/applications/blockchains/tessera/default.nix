{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "tessera";
  version = "0.10.2";

  src = fetchurl {
    url = "https://oss.sonatype.org/service/local/repositories/releases/content/com/jpmorgan/quorum/${pname}-app/${version}/${pname}-app-${version}-app.jar";
    sha256 = "1zn8w7q0q5man0407kb82lw4mlvyiy9whq2f6izf2b5415f9s0m4";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/tessera --add-flags "-jar $src"
  '';

  meta = with lib; {
    description = "Enterprise Implementation of Quorum's transaction manager";
    homepage = "https://github.com/jpmorganchase/tessera";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "tessera";
  };
}
