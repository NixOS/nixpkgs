{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commons-logging";
  version = "1.3.6";

  src = fetchurl {
    url = "mirror://apache/commons/logging/binaries/commons-logging-${finalAttrs.version}-bin.tar.gz";
    sha256 = "sha256-7+wHpv5x63E2u4KEStKz17DIOfqokYzwp/Q1/tBOBxE=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp commons-logging-*.jar $out/share/java/
  '';

  meta = {
    description = "Wrapper around a variety of logging API implementations";
    homepage = "https://commons.apache.org/proper/commons-logging";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
