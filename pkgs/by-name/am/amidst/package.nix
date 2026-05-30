{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amidst";
  version = "4.7";

  src = fetchurl {
    # TODO: Compile from src
    url = "https://github.com/toolbox4minecraft/amidst/releases/download/v${finalAttrs.version}/amidst-v${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }.jar";
    sha256 = "sha256-oecRjD7JUuvFym8N/hSE5cbAFQojS6yxOuxpwWRlW9M=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib/amidst}
    cp $src $out/lib/amidst/amidst.jar
    makeWrapper ${jre}/bin/java $out/bin/amidst \
      --add-flags "-jar $out/lib/amidst/amidst.jar"
  '';

  meta = {
    homepage = "https://github.com/toolbox4minecraft/amidst";
    description = "Advanced Minecraft Interface and Data/Structure Tracking";
    mainProgram = "amidst";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
