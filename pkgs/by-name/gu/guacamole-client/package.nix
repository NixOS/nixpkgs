{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "guacamole-client";
  version = "1.5.5";

  src = fetchurl {
    url = "mirror://apache/guacamole/${finalAttrs.version}/binary/guacamole-${finalAttrs.version}.war";
    hash = "sha256-QmcwfzYAZjcj8kr5LVlumcg1lCUxUTUFKkLUUflSkgA=";
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
    maintainers = [ lib.maintainers.drupol ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
    ];
  };
})
