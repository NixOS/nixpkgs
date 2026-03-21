{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jdom";
  version = "2.0.6.1";

  src = fetchzip {
    url = "http://www.jdom.org/dist/binary/jdom-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-Y++mlO+7N5EU2NhRzLl5x5WXNqu/2tDO/NpNhfRegcg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp -a . $out/share/java

    runHook postInstall
  '';

  meta = {
    description = "Java-based solution for accessing, manipulating, and outputting XML data from Java code";
    homepage = "http://www.jdom.org";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsdOriginal;
  };
})
