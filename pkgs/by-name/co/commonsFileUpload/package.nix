{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "1.5";
  pname = "commons-fileupload";

  src = fetchurl {
    url = "mirror://apache/commons/fileupload/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-r7EGiih4qOCbjaL7Wg+plbe0m3CuFWXs/RmbfGLmj1g=";
  };
  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp commons-fileupload-*-bin/*.jar $out/share/java/
  '';

  meta = with lib; {
    homepage = "https://commons.apache.org/proper/commons-fileupload";
    description = "Makes it easy to add robust, high-performance, file upload capability to your servlets and web applications";
    maintainers = with maintainers; [ copumpkin ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = with platforms; unix;
  };
}
