{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "jdom";
  version = "2.0.6.1";

  src = fetchzip {
    url = "https://www.jdom.org/dist/binary/jdom-${version}.zip";
    stripRoot = false;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp -a . $out/share/java

    runHook postInstall
  '';

  meta = with lib; {
    description = "Java-based solution for accessing, manipulating, and outputting XML data from Java code";
    homepage = "http://www.jdom.org";
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.bsdOriginal;
  };
}
