{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.17.0";
  pname = "commons-lang";

  src = fetchurl {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-CLk3Er7X9Icl2TxE1wxx5+ZhrzkPIvDz5rph46886jY=";
  };

  installPhase = ''
    runHook preInstall
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Provides additional methods to manipulate standard Java library classes";
    homepage = "https://commons.apache.org/proper/commons-lang";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
    platforms = with platforms; unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
