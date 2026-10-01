{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lombok";
  version = "1.18.46";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/lombok-${finalAttrs.version}.jar";
    sha256 = "sha256-AfexoBXjPiti1fXzcFMwY1erFBX9GB/Lp3lPXRmMESY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  outputs = [
    "out"
    "bin"
  ];

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar

    makeWrapper ${jdk}/bin/java $bin/bin/lombok \
      --add-flags "-cp ${jdk}/lib/openjdk/lib/tools.jar:$out/share/java/lombok.jar" \
      --add-flags lombok.launch.Main
  '';

  meta = {
    description = "Library that can write a lot of boilerplate for your Java project";
    mainProgram = "lombok";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    homepage = "https://projectlombok.org/";
    maintainers = [ lib.maintainers.CrystalGamma ];
  };
})
