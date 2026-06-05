{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5";
  pname = "commons-fileupload";

  src = fetchurl {
    url = "mirror://apache/commons/fileupload/binaries/commons-fileupload-${finalAttrs.version}-bin.tar.gz";
    sha256 = "sha256-r7EGiih4qOCbjaL7Wg+plbe0m3CuFWXs/RmbfGLmj1g=";
  };
  installPhase = ''
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp commons-fileupload-*-bin/*.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-fileupload";
    description = "Makes it easy to add robust, high-performance, file upload capability to your servlets and web applications";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
})
