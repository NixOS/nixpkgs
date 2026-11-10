{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "macse";
  version = "2.03";

  src = fetchurl {
    url = "https://bioweb.supagro.inra.fr/macse/releases/macse_v${finalAttrs.version}.jar";
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

  meta = {
    description = "Multiple alignment of coding sequences";
    mainProgram = "macse";
    homepage = "https://bioweb.supagro.inra.fr/macse/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.all;
  };
})
