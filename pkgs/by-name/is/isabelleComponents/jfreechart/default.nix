{
  stdenvNoCC,
  fetchurl,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jfreechart";
  version = "1.5.3";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/jfreechart-${finalAttrs.version}.tar.gz";
    hash = "sha256-39Un5RC9xi6252ZsPaUm2SDr3GaFc1KLvEJ+cphwEbs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/*.jar $out/lib

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "jfreechart-settings";
    text = ''
      JFREECHART_HOME="${finalAttrs.finalPackage}"

      classpath "$JFREECHART_HOME/lib/iText-2.1.5.jar"
      classpath "$JFREECHART_HOME/lib/jfreechart-1.5.3.jar"
    '';
    destination = "/etc/settings";
  };
})
