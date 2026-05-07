{
  lib,
  stdenv,
  fetchurl,
  jre8,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galen";
  version = "2.4.4";

  inherit jre8;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-${finalAttrs.version}/galen-bin-${finalAttrs.version}.zip";
    sha256 = "13dq8cf0yy24vym6z7p8hb0mybgpcl4j5crsaq8a6pjfxz6d17mq";
  };

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    cat galen | sed -e "s,java,$jre8/bin/java," > $out/bin/galen
    chmod +x $out/bin/galen
    cp galen.jar $out/bin
  '';

  meta = {
    homepage = "https://galenframework.com";
    description = "Automated layout testing for websites";
    mainProgram = "galen";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
