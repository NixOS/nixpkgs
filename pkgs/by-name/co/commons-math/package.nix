{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.6.1";
  pname = "commons-math";

  src = fetchurl {
    url = "mirror://apache/commons/math/binaries/commons-math3-${finalAttrs.version}-bin.tar.gz";
    sha256 = "0x4nx5pngv2n4ga11c1s4w2mf6cwydwkgs7da6wwvcjraw57bhkz";
  };

  installPhase = ''
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-math/";
    description = "Library of lightweight, self-contained mathematics and statistics components";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
})
