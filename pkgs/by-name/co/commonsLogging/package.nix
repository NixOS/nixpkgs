{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "commons-logging";
  version = "1.3.5";

  src = fetchurl {
    url = "mirror://apache/commons/logging/binaries/commons-logging-${version}-bin.tar.gz";
    sha256 = "sha256-4s/DfNYp/CXSIAtUAUHC2GReQrmlhpN8tRwvpHmB2G0=";
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
}
