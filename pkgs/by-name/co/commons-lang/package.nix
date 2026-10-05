{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.21.0";
  pname = "commons-lang";

  src = fetchurl {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-qeJOcsZwY+Rc59lHoa1A40Tsma19MH/skBaeaifh84k=";
  };

  installPhase = ''
    runHook preInstall
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
    runHook postInstall
  '';

  meta = {
    description = "Provides additional methods to manipulate standard Java library classes";
    homepage = "https://commons.apache.org/proper/commons-lang";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
