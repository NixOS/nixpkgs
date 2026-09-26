{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "guacamole-client";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://apache/guacamole/${finalAttrs.version}/binary/guacamole-${finalAttrs.version}.war";
    hash = "sha256-tBzrHi3wELVNtWPgsA7bjV/p8HPGFoRi5Ml43w/G5xY=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/webapps
    cp $src $out/webapps/guacamole.war

    runHook postInstall
  '';

  meta = {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.apache.org/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
    ];
  };
})
