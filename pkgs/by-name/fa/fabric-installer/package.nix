{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "fabric-installer";
  version = "1.1.0";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${version}/fabric-installer-${version}.jar";
    sha256 = "sha256-wgxAfVyksRmq6XhH6y+7HTTJKWm2R/u7HeL9NsoAc44=";
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

  meta = with lib; {
    homepage = "https://fabricmc.net/";
    description = "Lightweight, experimental modding toolchain for Minecraft";
    mainProgram = "fabric-installer";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
