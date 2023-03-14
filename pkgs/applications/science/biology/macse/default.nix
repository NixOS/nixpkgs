{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "macse";
  version = "2.03";

  src = fetchurl {
    url = "https://bioweb.supagro.inra.fr/${pname}/releases/${pname}_v${version}.jar";
    sha256 = "0jnjyz4f255glg37rawzdv4m6nfs7wfwc5dny7afvx4dz2sv4ssh";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    cp -s $src $out/share/java/macse.jar
    makeWrapper ${jre}/bin/java $out/bin/macse --add-flags "-jar $out/share/java/macse.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Multiple alignment of coding sequences";
    homepage = "https://bioweb.supagro.inra.fr/macse/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.all;
  };
}
