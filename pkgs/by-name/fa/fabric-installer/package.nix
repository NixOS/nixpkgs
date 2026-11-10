{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fabric-installer";
  version = "1.1.2";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${finalAttrs.version}/fabric-installer-${finalAttrs.version}.jar";
    hash = "sha256-YeA1v3v3AVPhJ0QM403kfJA28KLQxl0VKUVL01zu/k8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib/fabric}

    cp $src $out/lib/fabric/fabric-installer.jar
    makeWrapper ${jre}/bin/java $out/bin/fabric-installer \
      --add-flags "-jar $out/lib/fabric/fabric-installer.jar"
  '';

  meta = {
    homepage = "https://fabricmc.net/";
    description = "Lightweight, experimental modding toolchain for Minecraft";
    mainProgram = "fabric-installer";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
