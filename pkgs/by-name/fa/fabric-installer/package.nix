{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fabric-installer";
  version = "1.1.1";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${finalAttrs.version}/fabric-installer-${finalAttrs.version}.jar";
    hash = "sha256-JIemndb52cJgUmWnFC13wmq2LtxiDmvPgQ1YHS7jG3k=";
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
